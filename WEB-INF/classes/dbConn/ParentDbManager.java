package dbConn;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;

public class ParentDbManager {

    public static ArrayList<HashMap<String, String>> students = new ArrayList<HashMap<String, String>>();

    public ParentDbManager() throws ClassNotFoundException, SQLException {
        loadAllStudents();
    }

    public static LinkedHashSet<HashMap<String, String>> returnChildWithStudentIds(String[] childrenRegNumbers) {
        LinkedHashSet<HashMap<String, String>> childWithStudentIds = new LinkedHashSet<HashMap<String, String>>();
        for (String childRegNumber : childrenRegNumbers) {
            for (HashMap<String, String> student : students) {
                if (student.get("id").equals(childRegNumber)) {
                    HashMap<String, String> studentIdOfChild = new HashMap<String, String>();
                    studentIdOfChild.put("id", student.get("id"));
                    childWithStudentIds.add(studentIdOfChild);
                    break;
                }
            }
        }
        return childWithStudentIds;
    }

    public static void saveParentData(String name, String email, String password, String contact,
            String[] childrenRegNumbers)
            throws ClassNotFoundException, SQLException {

        password = PasswordEncryptor.encrypt(password);
        LinkedHashSet<HashMap<String, String>> childWithStudentIds = returnChildWithStudentIds(childrenRegNumbers);

        String sql = "INSERT INTO Parents (name, email, contactNumber) VALUES (?, ?, ?)";
        Integer parentId = null; // Initialize to null
        PreparedStatement statement = DbManager.getDbConnection().prepareStatement(sql,
                Statement.RETURN_GENERATED_KEYS);
        statement.setString(1, name);
        statement.setString(2, email);
        statement.setString(3, contact);
        int affectedRows = statement.executeUpdate();
        if (affectedRows == 1) {
            ResultSet generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                parentId = generatedKeys.getInt(1);
                if (childrenRegNumbers != null && childrenRegNumbers.length > 0) {
                    sql = "INSERT INTO ParentStudents (parentId, studentRegNumber) VALUES (?, ?)";
                    statement = DbManager.getDbConnection().prepareStatement(sql);
                    for (HashMap<String, String> childWithId : childWithStudentIds) {
                        statement.setInt(1, parentId);
                        statement.setString(2, childWithId.get("id"));
                        statement.executeUpdate();
                    }
                }
            }
        }

        // Insert login details
        String loginTableSql = "Insert into Login (id,userName, password,userType) values(?,?,?,?)";
        PreparedStatement loginTableStatement = DbManager.getDbConnection().prepareStatement(loginTableSql);
        loginTableStatement.setInt(1, parentId);
        loginTableStatement.setString(2, email);
        loginTableStatement.setString(3, password);
        loginTableStatement.setString(4, "Parent");
        loginTableStatement.executeUpdate();

    }

    public static void updateParentData(String id, String name, String email, String password, String contact,
            String[] childrenRegNumbers)
            throws ClassNotFoundException, SQLException {

        LinkedHashSet<HashMap<String, String>> childWithStudentIds = returnChildWithStudentIds(childrenRegNumbers);

        // Update parents table
        String parentTableSql = "UPDATE Parents SET name = ?, contactNumber = ?, email = ? WHERE parentId ="
                + id;

        PreparedStatement parentTableStatement = DbManager.getDbConnection().prepareStatement(parentTableSql);
        parentTableStatement.setString(1, name);
        parentTableStatement.setString(2, contact);
        parentTableStatement.setString(3, email);
        
        parentTableStatement.executeUpdate();

        // Update login student details
        String loginTableSql = "UPDATE Login SET userName = ? WHERE id ="
                + id;
        PreparedStatement loginTableStatement = DbManager.getDbConnection().prepareStatement(loginTableSql);
        loginTableStatement.setString(1, email);
        loginTableStatement.executeUpdate();

        // Update student-child table with parent id
        DbManager.excuteDeleteQuery("DELETE FROM ParentStudents WHERE parentId=" + id);
        if (childrenRegNumbers != null && childrenRegNumbers.length > 0) {
            String sql = "INSERT INTO ParentStudents (parentId, studentRegNumber) VALUES (?, ?)";
            PreparedStatement statement = DbManager.getDbConnection().prepareStatement(sql);
            for (HashMap<String, String> childWithId : childWithStudentIds) {
                statement.setString(1, id);
                statement.setString(2, childWithId.get("id"));
                statement.executeUpdate();
            }
        }

    }

    public static void loadAllStudents() throws ClassNotFoundException, SQLException {
        ResultSet studentResultSet = DbManager.getDbConnection().createStatement()
                .executeQuery("SELECT * FROM Students");
        while (studentResultSet.next()) {
            HashMap<String, String> student = new HashMap<String, String>();
            student.put("id", studentResultSet.getString("studentRegNumber"));
            students.add(student);
        }
    }

    public static boolean checkIfAnyRegNumberNotExistsInList(String[] childrenRegNumbers) {
        for (String childrenRegNumber : childrenRegNumbers) {
            boolean regNumExists = false;
            for (HashMap<String, String> student : students) {
                if (student.containsValue(childrenRegNumber)) {
                    regNumExists = true;
                    break;
                }
            }
            if (!regNumExists) {
                return true;
            }
        }
        return false;
    }
    // If we have checked all the emails in the childrenRegNumbers array and none of them
    // were found to be missing from the students list, we return false to indicate
    // that all the emails are present in the list.

}

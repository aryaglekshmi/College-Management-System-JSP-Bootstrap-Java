package dbConn;

import java.sql.*;


public class TeacherDbManager {

	public static void saveTeachersData(String name, String salary, String[] subjects, String mail, String password)
			throws ClassNotFoundException, SQLException {

				password = PasswordEncryptor.encrypt(password);
		// Insert teachers table
		String teacherTableSql = "Insert into Teachers (name,salary,teacherEmail) values(?,?,?)";
		PreparedStatement teacherTableStatement = DbManager.getDbConnection().prepareStatement(teacherTableSql,
				Statement.RETURN_GENERATED_KEYS);
		teacherTableStatement.setString(1, name);
		teacherTableStatement.setString(2, salary);
		teacherTableStatement.setString(3, mail);
		teacherTableStatement.executeUpdate();

		// Get genertaed teacher Id
		ResultSet generatedKeys = teacherTableStatement.getGeneratedKeys();
		generatedKeys.next();
		String teacherId = generatedKeys.getInt(1) + "";

		// Insert login details
		String loginTableSql = "Insert into Login (id,userName, password,userType) values(?,?,?,?)";
		PreparedStatement loginTableStatement = DbManager.getDbConnection().prepareStatement(loginTableSql);
		loginTableStatement.setString(1, teacherId);
		loginTableStatement.setString(2, mail);
		loginTableStatement.setString(3, password);
		loginTableStatement.setString(4, "Teacher");
		loginTableStatement.executeUpdate();

		// Insert sujects table with teacher id
		Statement statement = DbManager.getDbConnection().createStatement();
		for (String subject : subjects) {
			statement.addBatch(
					"INSERT INTO TeacherSubjects (teacherId, name) VALUES (" + teacherId + ", '" + subject + "');");
		}
		statement.executeBatch();
	}

	public static void updateTeacherData(String id, String name, String salary, String[] subjects, String email
			) throws ClassNotFoundException, SQLException {



		// Update teachers table
		String teacherTableSql = "UPDATE Teachers SET name = ?, salary = ?, teacherEmail = ? WHERE teacherId ="
				+ id;

		PreparedStatement teacherTableStatement = DbManager.getDbConnection().prepareStatement(teacherTableSql);
		teacherTableStatement.setString(1, name);
		teacherTableStatement.setString(2, salary);
		teacherTableStatement.setString(3, email);
		teacherTableStatement.executeUpdate();

		// Update login student details
		String loginTableSql = "UPDATE Login SET userName = ? WHERE id ="
				+ id;
		PreparedStatement loginTableStatement = DbManager.getDbConnection().prepareStatement(loginTableSql);
		loginTableStatement.setString(1, email);
		loginTableStatement.executeUpdate();

		// Update sujects table with teacher id
		Statement statement = DbManager.getDbConnection().createStatement();
		DbManager.excuteDeleteQuery("DELETE FROM TeacherSubjects WHERE teacherId=" + id);
		for (String subject : subjects) {
			statement.addBatch("INSERT INTO TeacherSubjects (teacherId, name) VALUES (" +
			id + ", '" + subject + "');");
		}
		statement.executeBatch();

	}

}

package dbConn;

import java.sql.*;
import java.util.*;

public class StudentDbManager {

	public static boolean saveStudentData(String regNumber, String name, String course, String permanentAddress,
			String presentAddress,
			String email, String password)
			throws ClassNotFoundException, SQLException {

		if (checkRegistratioNumberDuplicates(regNumber)) {
			return false;
		} else {
			password = PasswordEncryptor.encrypt(password);
			// Get exam fee and course fee
			HashMap<String, String> feeDetails = new HashMap<>();
			feeDetails = getCourseFee(course);

			// Insert students table
			String studentTableSql = "Insert into Students (studentRegNumber,name,course,courseFee,examFee,studentEmail) values(?,?,?,?,?,?)";
			PreparedStatement studentTableStatement = DbManager.getDbConnection().prepareStatement(studentTableSql);
			studentTableStatement.setString(1, regNumber);
			studentTableStatement.setString(2, name);
			studentTableStatement.setString(3, course);
			studentTableStatement.setString(4, feeDetails.get("courseFee"));
			studentTableStatement.setString(5, feeDetails.get("examFee"));
			studentTableStatement.setString(6, email);
			studentTableStatement.executeUpdate();

			// Insert login details
			String loginTableSql = "Insert into Login (id,userName, password,userType) values(?,?,?,?)";
			PreparedStatement loginTableStatement = DbManager.getDbConnection().prepareStatement(loginTableSql);
			loginTableStatement.setString(1, regNumber);
			loginTableStatement.setString(2, email);
			loginTableStatement.setString(3, password);
			loginTableStatement.setString(4, "Student");
			loginTableStatement.executeUpdate();

			// Add address details
			String addressTableSql = "Insert into StudentAddress (studentRegNumber,presentAddress, permanentAddress) values(?,?,?)";
			PreparedStatement addressTableStatement = DbManager.getDbConnection().prepareStatement(addressTableSql);
			addressTableStatement.setString(1, regNumber);
			addressTableStatement.setString(2, presentAddress);
			addressTableStatement.setString(3, permanentAddress);
			addressTableStatement.executeUpdate();
			return true;
		}
	}

	public static boolean checkRegistratioNumberDuplicates(String regNumber)
			throws ClassNotFoundException, SQLException {
		ResultSet duplicates = DbManager.excuteGetQuery("Select * from Students where studentRegNumber=" + regNumber);
		if (duplicates.next()) {
			return true;
		}
		return false;
	}

	public static void updateStudentData(String id, String name,
			String course, String permanentAddress, String presentAddress, String email)
			throws ClassNotFoundException, SQLException {

			// Get exam fee and course fee
			HashMap<String, String> feeDetails = new HashMap<>();
			feeDetails = getCourseFee(course);

			// Update students table
			String studentTableSql = "UPDATE students SET name = ?, course = ?, courseFee = ?, examFee = ?, studentEmail = ? WHERE studentRegNumber ="
					+ id;

			PreparedStatement studentTableStatement = DbManager.getDbConnection().prepareStatement(studentTableSql);
			studentTableStatement.setString(1, name);
			studentTableStatement.setString(2, course);
			studentTableStatement.setString(3, feeDetails.get("courseFee"));
			studentTableStatement.setString(4, feeDetails.get("examFee"));
			studentTableStatement.setString(5, email);
			studentTableStatement.executeUpdate();

			// Update login student details
			String loginTableSql = "UPDATE Login SET userName = ? WHERE id ="
					+ id;
			PreparedStatement loginTableStatement = DbManager.getDbConnection().prepareStatement(loginTableSql);
			loginTableStatement.setString(1, email);
			loginTableStatement.executeUpdate();

			// Update address details
			String addressTableSql = "Update StudentAddress SET studentRegNumber = ?, presentAddress = ?, permanentAddress = ?  WHERE studentRegNumber ="
					+ id;
			PreparedStatement addressTableStatement = DbManager.getDbConnection().prepareStatement(addressTableSql);
			addressTableStatement.setString(1, id);
			addressTableStatement.setString(2, presentAddress);
			addressTableStatement.setString(3, permanentAddress);
			addressTableStatement.executeUpdate();

	}

	public static HashMap<String, String> getCourseFee(String course) throws ClassNotFoundException, SQLException {
		String sql = "SELECT * FROM FeeStructure WHERE course = ?";
		PreparedStatement statement = DbManager.getDbConnection().prepareStatement(sql);
		statement.setString(1, course);
		ResultSet resultSet = statement.executeQuery();
		HashMap<String, String> fees = new HashMap<>();
		while (resultSet.next()) {
			fees.put("courseFee", resultSet.getString("courseFee"));
			fees.put("examFee", resultSet.getString("examFee"));
		}
		return fees;
	}

	public static void bulkUpdateStudentData(String id, String name, String course, String maths, String science,
			String malayalam, String permanentAddress, String presentAddress)
			throws ClassNotFoundException, SQLException {

	}

	public static void bulkDeleteStudentData(String[] studentIds) throws ClassNotFoundException, SQLException {
		String studentIdsToDelete = "";
		for (String id : studentIds) {
			studentIdsToDelete += id;
			if (id == studentIds[studentIds.length - 1]) {
				studentIdsToDelete += ')';
			} else {
				studentIdsToDelete += ',';
			}
		}
		List<String> deleteQueries = new ArrayList<String>();
		deleteQueries.add("DELETE FROM StudentAddress WHERE studentRegNumber IN (" + studentIdsToDelete);
		deleteQueries.add("DELETE FROM Marks WHERE studentRegNumber IN (" + studentIdsToDelete);
		deleteQueries.add("DELETE FROM Students WHERE studentRegNumber IN (" + studentIdsToDelete);
		DbManager.excuteQueryBathes(deleteQueries);
	}

	public static void checkStudentAttendanceReport(String id, String course, String semester, String date,
			String status)
			throws ClassNotFoundException, SQLException {

		String[] attendanceTables = { "PresentReport", "AbsentReport" };
		for (int i = 0; i < attendanceTables.length; i++) {
			checkAndDeleteExistAttendance(attendanceTables[i], id, course, semester, date, status);
		}

	}

	public static void addAttendanceReport(String id, String course, String semester, String date,
			String status)
			throws ClassNotFoundException, SQLException {
		int presentCount = 0;
		int absentCount = 0;
		PreparedStatement presentStmt = DbManager.getDbConnection().prepareStatement(
				"SELECT COUNT(*) AS present_count FROM PresentReport WHERE course = ? AND studentRegNumber = ? AND semester = ?");
		presentStmt.setString(1, course);
		presentStmt.setString(2, id);
		presentStmt.setString(3, semester);
		ResultSet presentResultSet = presentStmt.executeQuery();

		if (presentResultSet.next()) {
			presentCount = presentResultSet.getInt("present_count");
		}
		PreparedStatement absentStmt = DbManager.getDbConnection().prepareStatement(
				"SELECT COUNT(*) AS absent_count FROM AbsentReport WHERE course = ? AND studentRegNumber = ? AND semester = ?");
		absentStmt.setString(1, course);
		absentStmt.setString(2, id);
		absentStmt.setString(3, semester);
		ResultSet absentResultSet = absentStmt.executeQuery();

		if (absentResultSet.next()) {
			absentCount = absentResultSet.getInt("absent_count");
		}

		PreparedStatement attendanceStmt = DbManager.getDbConnection().prepareStatement(
				"SELECT * FROM AttendanceReports WHERE studentRegNumber = ? AND course = ? AND semester = ?");
		attendanceStmt.setString(1, id);
		attendanceStmt.setString(2, course);
		attendanceStmt.setString(3, semester);
		ResultSet studentResultSet = attendanceStmt.executeQuery();

		if (studentResultSet.next()) {
			String reportId = studentResultSet.getString("reportId");
			PreparedStatement updateStmt = DbManager.getDbConnection().prepareStatement(
					"UPDATE AttendanceReports SET totalAbsent = ?, totalPresent = ? WHERE reportId = ?");
			updateStmt.setInt(1, absentCount);
			updateStmt.setInt(2, presentCount);
			updateStmt.setString(3, reportId);
			updateStmt.executeUpdate();

		} else {
			PreparedStatement insertStmt = DbManager.getDbConnection().prepareStatement(
					"INSERT INTO AttendanceReports (studentRegNumber, course, semester, totalAbsent, totalPresent) VALUES (?, ?, ?, ?, ?)");
			insertStmt.setString(1, id);
			insertStmt.setString(2, course);
			insertStmt.setString(3, semester);
			insertStmt.setInt(4, absentCount);
			insertStmt.setInt(5, presentCount);
			insertStmt.executeUpdate();

		}

	}

	public static void checkAndDeleteExistAttendance(String table, String id, String course, String semester,
			String date, String status)
			throws ClassNotFoundException, SQLException {
		PreparedStatement stmt = DbManager.getDbConnection().prepareStatement(
				"SELECT reportId from " + table + " WHERE studentRegNumber=? and date=?");
		stmt.setString(1, id);
		// stmt.setString(2, course);
		// stmt.setString(3, semester);
		stmt.setString(2, date);
		ResultSet resultset = stmt.executeQuery();
		if (resultset.next()) {
			DbManager
					.excuteDeleteQuery("DELETE from " + table + " WHERE reportId = " + resultset.getString("reportId"));
		}
	}

}

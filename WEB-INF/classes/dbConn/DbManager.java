package dbConn;

import java.sql.*;
import java.util.*;

public class DbManager {

	private static Connection connection;


	public static Connection getDbConnection() throws ClassNotFoundException, SQLException {
		if (connection == null) {
			Class.forName("com.mysql.cj.jdbc.Driver");
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Arya_DB", "root", "12345678");
		}
		return connection;

	}

	public static ResultSet excuteGetQuery(String query) throws ClassNotFoundException, SQLException {
		Connection conn = getDbConnection();
		Statement statement = conn.createStatement();
		return statement.executeQuery(query);
	}

	public static void excuteDeleteQuery(String deleteQuery) throws ClassNotFoundException, SQLException {
		Connection conn = getDbConnection();
		conn.createStatement().executeUpdate(deleteQuery);
	}

	public static void excuteQueryBathes(List<String> queries) throws ClassNotFoundException, SQLException {
		Connection conn = getDbConnection();
		Statement statement = conn.createStatement();
		for (String query : queries) {
			statement.addBatch(query);
		}
		statement.executeBatch();
	}

	public static String toCapitalCase(String str) {
		if (str == null || str.isEmpty()) {
			return str;
		}
		String[] words = str.split("\\s+");
		StringBuilder sb = new StringBuilder();
		for (String word : words) {
			sb.append(Character.toUpperCase(word.charAt(0)));
			sb.append(word.substring(1).toLowerCase());
			sb.append(" ");
		}
		return sb.toString().trim();
	}


}

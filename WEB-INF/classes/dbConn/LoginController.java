package dbConn;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;


public class LoginController {
    
	public static HashMap<String,String> doLogin(String username, String password) throws ClassNotFoundException, SQLException {

		password = PasswordEncryptor.encrypt(password);
		String sql = "SELECT * FROM Login WHERE username = ? AND password = ?";
		PreparedStatement statement = DbManager.getDbConnection().prepareStatement(sql);
		statement.setString(1, username);
		statement.setString(2, password);
		ResultSet loginResultSet = statement.executeQuery();
		if (loginResultSet.next()) {
            HashMap<String,String> loginUser = new HashMap<>();
            loginUser.put("userType", loginResultSet.getString("userType"));
            loginUser.put("userId", loginResultSet.getString("id"));
			return loginUser;
		}
		
		return null;

	}

}

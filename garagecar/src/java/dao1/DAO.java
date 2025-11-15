package dao1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/garage?serverTimezone=Asia/Ho_Chi_Minh";
    private final String USER = "root"; 
    private final String PASS = "vngclinh"; 

    public Connection getConnection() throws Exception {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 

            return DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (SQLException e) {
            throw new Exception("Lỗi kết nối CSDL: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            throw new Exception("Không tìm thấy driver MySQL: " + e.getMessage());
        }
    }

    public static void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

package dao; 
import model.SystemUser;
import model.Customer;
import model.Employee;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SystemUserDAO {

    public SystemUser checkLogin(String username, String password) throws Exception {
        
        String trimmedUsername = username.trim(); 
        String trimmedPassword = password.trim(); 
        
        // 1. SQL để kiểm tra tài khoản chung
        String sqlCheckUser = "SELECT * FROM tblSystemUser WHERE username = ? AND password = ?";
        
        // 2. SQL để kiểm tra nếu là Employee (JOIN để lấy position)
        String sqlCheckEmployee = "SELECT e.position FROM tblEmployee e WHERE e.tblSystemUserid = ?";
        
        // 3. SQL để kiểm tra nếu là Customer (chỉ cần kiểm tra sự tồn tại)
        String sqlCheckCustomer = "SELECT tblSystemUserid FROM tblCustomer WHERE tblSystemUserid = ?";

        SystemUser user = null;

        try (Connection conn = new DAO().getConnection()) {
            
            try (PreparedStatement ps = conn.prepareStatement(sqlCheckUser)) {
                ps.setString(1, trimmedUsername);
                ps.setString(2, trimmedPassword);
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int id = rs.getInt("id");
                        
                        user = new SystemUser(
                            id,
                            rs.getString("fullname"),
                            rs.getString("phoneNum"),
                            rs.getDate("dob"),
                            rs.getString("address"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("email")
                        );
                        
                    } else {
                        return null; 
                    }
                }
            }
            
            try (PreparedStatement ps = conn.prepareStatement(sqlCheckEmployee)) {
                ps.setInt(1, user.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String position = rs.getString("position");
                        return new Employee(
                            user.getId(), user.getFullname(), user.getPhoneNum(), 
                            user.getDob(), user.getAddress(), user.getUsername(), 
                            user.getPassword(), user.getEmail(), position
                        );
                    }
                }
            }
            
            try (PreparedStatement ps = conn.prepareStatement(sqlCheckCustomer)) {
                ps.setInt(1, user.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return new Customer(
                            user.getId(), user.getFullname(), user.getPhoneNum(), 
                            user.getDob(), user.getAddress(), user.getUsername(), 
                            user.getPassword(), user.getEmail()
                        );
                    }
                }
            }
            
            return user;

        } catch (SQLException e) {
            System.err.println(" LỖI SQL TRONG checkLogin: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Lỗi truy vấn CSDL: " + e.getMessage(), e);
        }
    }
}

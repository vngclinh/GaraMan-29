package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.Appointment;

public class AppointmentDAO {

    public boolean addAppointment(Appointment appointment) throws Exception {
        String sql = "INSERT INTO tblAppointment (creationTime, appointmentTime, status, note, customerId) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = new DAO().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, java.sql.Timestamp.valueOf(appointment.getCreationTime()));
            ps.setTimestamp(2, java.sql.Timestamp.valueOf(appointment.getAppointmentTime()));
            ps.setString(3, appointment.getStatus());
            ps.setString(4, appointment.getNote());
            ps.setInt(5, appointment.getCustomer().getId());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("SQL error in addAppointment(): " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Database insert failed: " + e.getMessage(), e);
        }
    }
}

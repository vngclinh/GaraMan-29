package dao;

import java.sql.*;
import java.util.ArrayList;
import model.ServiceStats;

public class ServiceStatsDAO extends DAO {

    public ServiceStatsDAO() {
        super();
    }

    public ArrayList<ServiceStats> getServiceStats(Date startDate, Date endDate) {
        ArrayList<ServiceStats> result = new ArrayList<>();

        String sql = """
            SELECT s.id, s.name, s.price, s.estimatedTime, s.description,
                   COALESCE(SUM(us.unitPrice * us.quantity), 0) AS totalRevenue,
                   COALESCE(SUM(us.quantity), 0) AS totalQuantity
            FROM tblService s
            LEFT JOIN tblUsedService us ON s.id = us.tblServiceId
            LEFT JOIN tblInvoice i ON us.tblInvoiceId = i.id
            WHERE i.creationTime BETWEEN ? AND ?
              AND i.status = 'done'
            GROUP BY s.id, s.name, s.price, s.estimatedTime, s.description
            ORDER BY totalRevenue DESC, totalQuantity DESC
        """;

        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, new Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new Timestamp(endDate.getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceStats s = new ServiceStats();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setPrice(rs.getFloat("price"));
                    s.setEstimatedTime(rs.getInt("estimatedTime"));
                    s.setDescription(rs.getString("description"));
                    s.setTotalRevenue(rs.getFloat("totalRevenue"));
                    s.setTotalQuantity(rs.getInt("totalQuantity"));
                    result.add(s);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}

package dao1;

import java.sql.*;
import java.util.ArrayList;
import model.PartStats;

public class PartStatsDAO extends DAO {

    public PartStatsDAO() {
        super();
    }

    public ArrayList<PartStats> getPartStats(Date startDate, Date endDate) {
        ArrayList<PartStats> result = new ArrayList<>();

        String sql = """
            SELECT p.id, p.name, p.price, p.remainQuantity, p.description,
                   COALESCE(SUM(up.unitPrice * up.quantity), 0) AS totalRevenue,
                   COALESCE(SUM(up.quantity), 0) AS totalQuantity
            FROM tblPart p
            LEFT JOIN tblUsedPart up ON p.id = up.tblPartId
            LEFT JOIN tblInvoice i ON up.tblInvoiceId = i.id
            WHERE i.creationTime BETWEEN ? AND ?
              AND i.status = 'done'
            GROUP BY p.id, p.name, p.price, p.remainQuantity, p.description
            ORDER BY totalRevenue DESC, totalQuantity DESC
        """;

        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, new Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new Timestamp(endDate.getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PartStats p = new PartStats();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getFloat("price"));
                    p.setRemainQuantity(rs.getInt("remainQuantity"));
                    p.setDescription(rs.getString("description"));
                    p.setTotalRevenue(rs.getFloat("totalRevenue"));
                    p.setTotalQuantity(rs.getInt("totalQuantity"));
                    result.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}

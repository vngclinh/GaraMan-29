package dao1;

import model.*;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;

public class InvoiceDAO extends DAO {

    public InvoiceDAO() {
        super();
    }

    // Lấy danh sách hóa đơn có chứa SERVICE cụ thể trong khoảng ngày
    public ArrayList<Invoice> getListInvoiceByService(int serviceId, LocalDate startDate, LocalDate endDate) {
        ArrayList<Invoice> list = new ArrayList<>();

        String sql = """
            SELECT i.id, i.creationTime, i.status, su.fullname AS customerName,
                   COALESCE(sv.totalService, 0) + COALESCE(pt.totalPart, 0) AS total,
                   us.quantity AS serviceQty, us.unitPrice AS servicePrice
            FROM tblInvoice i
            JOIN tblCustomer c ON i.customerid = c.tblSystemUserid
            JOIN tblSystemUser su ON su.id = c.tblSystemUserid
            LEFT JOIN tblUsedService us ON us.tblInvoiceId = i.id AND us.tblServiceId = ?
            LEFT JOIN (
                SELECT up.tblInvoiceId, SUM(up.unitPrice * up.quantity) AS totalPart
                FROM tblUsedPart up
                GROUP BY up.tblInvoiceId
            ) pt ON pt.tblInvoiceId = i.id
            LEFT JOIN (
                SELECT us2.tblInvoiceId, SUM(us2.unitPrice * us2.quantity) AS totalService
                FROM tblUsedService us2
                GROUP BY us2.tblInvoiceId
            ) sv ON sv.tblInvoiceId = i.id
            WHERE i.status = 'done'
              AND i.creationTime BETWEEN ? AND ?
              AND us.tblServiceId IS NOT NULL
            ORDER BY i.id ASC
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ps.setTimestamp(2, Timestamp.valueOf(startDate.atStartOfDay()));
            ps.setTimestamp(3, Timestamp.valueOf(endDate.atTime(23, 59, 59)));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = new Invoice();
                    inv.setId(rs.getInt("id"));
                    inv.setCreationTime(rs.getTimestamp("creationTime").toLocalDateTime());
                    inv.setStatus(rs.getString("status"));
                    inv.setTotal(rs.getFloat("total"));

                    Customer c = new Customer();
                    c.setFullname(rs.getString("customerName"));
                    inv.setCustomer(c);

                    UsedService us = new UsedService();
                    us.setQuantity(rs.getInt("serviceQty"));
                    us.setUnitPrice(rs.getFloat("servicePrice"));
                    ArrayList<UsedService> lst = new ArrayList<>();
                    lst.add(us);
                    inv.setListService(lst);

                    list.add(inv);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách hóa đơn có chứa PART cụ thể trong khoảng ngày
    public ArrayList<Invoice> getListInvoiceByPart(int partId, LocalDate startDate, LocalDate endDate) {
        ArrayList<Invoice> list = new ArrayList<>();

        String sql = """
            SELECT i.id, i.creationTime, i.status, su.fullname AS customerName,
                   COALESCE(sv.totalService, 0) + COALESCE(pt.totalPart, 0) AS total,
                   up.quantity AS partQty, up.unitPrice AS partPrice
            FROM tblInvoice i
            JOIN tblCustomer c ON i.customerid = c.tblSystemUserid
            JOIN tblSystemUser su ON su.id = c.tblSystemUserid
            LEFT JOIN tblUsedPart up ON up.tblInvoiceId = i.id AND up.tblPartId = ?
            LEFT JOIN (
                SELECT up2.tblInvoiceId, SUM(up2.unitPrice * up2.quantity) AS totalPart
                FROM tblUsedPart up2
                GROUP BY up2.tblInvoiceId
            ) pt ON pt.tblInvoiceId = i.id
            LEFT JOIN (
                SELECT us.tblInvoiceId, SUM(us.unitPrice * us.quantity) AS totalService
                FROM tblUsedService us
                GROUP BY us.tblInvoiceId
            ) sv ON sv.tblInvoiceId = i.id
            WHERE i.status = 'done'
              AND i.creationTime BETWEEN ? AND ?
              AND up.tblPartId IS NOT NULL
            ORDER BY i.id ASC
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, partId);
            ps.setTimestamp(2, Timestamp.valueOf(startDate.atStartOfDay()));
            ps.setTimestamp(3, Timestamp.valueOf(endDate.atTime(23, 59, 59)));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = new Invoice();
                    inv.setId(rs.getInt("id"));
                    inv.setCreationTime(rs.getTimestamp("creationTime").toLocalDateTime());
                    inv.setStatus(rs.getString("status"));
                    inv.setTotal(rs.getFloat("total"));

                    Customer c = new Customer();
                    c.setFullname(rs.getString("customerName"));
                    inv.setCustomer(c);

                    UsedPart up = new UsedPart();
                    up.setQuantity(rs.getInt("partQty"));
                    up.setUnitPrice(rs.getFloat("partPrice"));
                    ArrayList<UsedPart> lst = new ArrayList<>();
                    lst.add(up);
                    inv.setListPart(lst);

                    list.add(inv);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Invoice getInvoiceDetail(int invoiceId) {
        Invoice inv = null;

        String sql = """
            SELECT i.id AS invoice_id, i.creationTime, i.status,
                   car.id AS car_id, car.plateNum, car.name AS car_name, car.brand,
                   pay.id AS payment_id, pay.method AS payment_method, pay.date as pay_date,
                   slot.id as slot_id, slot.name as slot_name, slot.note as slot_note,
                   
                   cus.tblSystemUserid AS customer_sys_id,
                   u1.fullname AS customer_name,
                   u1.phoneNum AS customer_phone,
                   u1.address AS customer_address,
                   
                   emp.tblSystemUserid AS staff_sys_id,
                   u2.fullname AS staff_name
            FROM tblInvoice i
            LEFT JOIN tblCar car ON i.tblCarid = car.id
            LEFT JOIN tblPayment pay ON i.tblPaymentid = pay.id
            LEFT JOIN tblCustomer cus ON i.customerid = cus.tblSystemUserid
            LEFT JOIN tblSystemUser u1 ON cus.tblSystemUserid = u1.id
            LEFT JOIN tblEmployee emp ON i.staffId = emp.tblSystemUserid
            LEFT JOIN tblSystemUser u2 ON emp.tblSystemUserid = u2.id
            left join tblSlot slot ON i.tblslotid = slot.id
            WHERE i.id = ?
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                inv = new Invoice();
                inv.setId(rs.getInt("invoice_id"));
                inv.setCreationTime(rs.getTimestamp("creationTime").toLocalDateTime());
                inv.setStatus(rs.getString("status"));

                // Customer
                Customer c = new Customer();
                c.setId(rs.getInt("customer_sys_id"));
                c.setFullname(rs.getString("customer_name"));
                c.setPhoneNum(rs.getString("customer_phone"));
                c.setAddress(rs.getString("customer_address"));
                inv.setCustomer(c);
                
                //slot
                Slot s = new Slot();
                s.setId(rs.getInt("slot_id"));
                s.setName(rs.getString("slot_name"));
                s.setNote(rs.getString("slot_note"));
                inv.setSlot(s);

                // Staff
                Employee emp = new Employee();
                emp.setId(rs.getInt("staff_sys_id"));
                emp.setFullname(rs.getString("staff_name"));
                inv.setStaff(emp);

                // Car
                Car car = new Car();
                car.setId(rs.getInt("car_id"));
                car.setPlateNum(rs.getString("plateNum"));
                car.setName(rs.getString("car_name"));
                car.setBrand(rs.getString("brand"));
                inv.setCar(car);

                // Payment
                Payment pay = new Payment();
                pay.setId(rs.getInt("payment_id"));
                pay.setMethod(rs.getString("payment_method"));
                pay.setDate(rs.getTimestamp("pay_date").toLocalDateTime());
                inv.setPayment(pay);

                // Lấy danh sách dịch vụ và linh kiện
                inv.setListService(getUsedServicesByInvoice(invoiceId, con));
                inv.setListPart(getUsedPartsByInvoice(invoiceId, con));

                // Tính tổng tiền (service + part)
                float total = 0;
                for (UsedService us : inv.getListService()) {
                    total += us.getUnitPrice() * us.getQuantity();
                }
                for (UsedPart up : inv.getListPart()) {
                    total += up.getUnitPrice() * up.getQuantity();
                }
//                total = total *(1-pay.getDiscount());
                inv.setTotal(total);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return inv;
    }

    private ArrayList<UsedService> getUsedServicesByInvoice(int invoiceId, Connection con) throws SQLException {
        ArrayList<UsedService> list = new ArrayList<>();
        String sql = """
            SELECT us.id, us.unitPrice, us.quantity,
                   sv.id AS service_id, sv.name AS service_name
            FROM tblUsedService us
            JOIN tblService sv ON us.tblServiceId = sv.id
            WHERE us.tblInvoiceId = ?
        """;
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, invoiceId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            UsedService us = new UsedService();
            us.setId(rs.getInt("id"));
            us.setUnitPrice(rs.getFloat("unitPrice"));
            us.setQuantity(rs.getInt("quantity"));

            Service s = new Service();
            s.setId(rs.getInt("service_id"));
            s.setName(rs.getString("service_name"));
            us.setService(s);

            us.setListTechstaff(getServiceTechstaff(rs.getInt("id"), con));
            list.add(us);
        }

        return list;
    }

    private ArrayList<ServiceTechstaff> getServiceTechstaff(int usedServiceId, Connection con) throws SQLException {
        ArrayList<ServiceTechstaff> list = new ArrayList<>();
        String sql = """
            SELECT st.id, su.fullname
            FROM tblServiceTechstaff st
            JOIN tblEmployee e ON st.staffId = e.tblSystemUserid
            JOIN tblSystemUser su ON e.tblSystemUserid = su.id
            WHERE st.tblUsedServiceid = ?
        """;
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, usedServiceId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            ServiceTechstaff st = new ServiceTechstaff();
            Employee emp = new Employee();
            emp.setFullname(rs.getString("fullname"));
            st.setTechnician(emp);
            list.add(st);
        }

        return list;
    }

    private ArrayList<UsedPart> getUsedPartsByInvoice(int invoiceId, Connection con) throws SQLException {
        ArrayList<UsedPart> list = new ArrayList<>();
        String sql = """
            SELECT up.id, up.unitPrice, up.quantity,
                   pt.id AS part_id, pt.name AS part_name
            FROM tblUsedPart up
            JOIN tblPart pt ON up.tblPartId = pt.id
            WHERE up.tblInvoiceId = ?
        """;
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, invoiceId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            UsedPart up = new UsedPart();
            up.setId(rs.getInt("id"));
            up.setUnitPrice(rs.getFloat("unitPrice"));
            up.setQuantity(rs.getInt("quantity"));

            Part p = new Part();
            p.setId(rs.getInt("part_id"));
            p.setName(rs.getString("part_name"));
            up.setPart(p);

            list.add(up);
        }

        return list;
    }
}

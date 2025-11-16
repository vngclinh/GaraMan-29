package servlet;

import dao.InvoiceDAO;
import model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/InvoiceController")
public class InvoiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String invoiceIdParam = request.getParameter("invoiceId");
        InvoiceDAO dao = new InvoiceDAO();

        //  Trường hợp xem chi tiết 1 hóa đơn
        if (invoiceIdParam != null) {
            try {
                int invoiceId = Integer.parseInt(invoiceIdParam);
                Invoice invoice = dao.getInvoiceDetail(invoiceId);

                request.setAttribute("invoice", invoice);
                request.getRequestDispatcher("/staff/DetailsInvoiceView.jsp").forward(request, response);
                return;

            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID");
                return;
            }
        }

        // Trường hợp xem danh sách hóa đơn chứa 1 service hoặc part
        try {
            String type = request.getParameter("type"); // "service" hoặc "part"
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            LocalDate start = LocalDate.parse(request.getParameter("start"));
            LocalDate end = LocalDate.parse(request.getParameter("end"));

            ArrayList<Invoice> invoices;

            if ("service".equalsIgnoreCase(type)) {
                invoices = dao.getListInvoiceByService(id, start, end);
            } else {
                invoices = dao.getListInvoiceByPart(id, start, end);
            }

            //  Map để hiển thị UsedService / UsedPart tương ứng
            Map<Integer, Object> itemMap = new HashMap<>();

            for (Invoice inv : invoices) {
                if ("service".equalsIgnoreCase(type) && inv.getListService() != null && !inv.getListService().isEmpty()) {
                    itemMap.put(inv.getId(), inv.getListService().get(0)); 
                } else if ("part".equalsIgnoreCase(type) && inv.getListPart() != null && !inv.getListPart().isEmpty()) {
                    itemMap.put(inv.getId(), inv.getListPart().get(0)); 
                }
            }

            request.setAttribute("invoiceList", invoices);
            request.setAttribute("itemMap", itemMap);
            request.setAttribute("itemName", name);
            request.setAttribute("type", type);
            request.setAttribute("start", start);
            request.setAttribute("end", end);

            RequestDispatcher rd = request.getRequestDispatcher("/staff/DetailsView.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }
}

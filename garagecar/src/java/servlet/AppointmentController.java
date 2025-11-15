package servlet;

import dao1.AppointmentDAO;
import model.Appointment;
import model.Customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.time.*;

@WebServlet("/AppointmentController")
public class AppointmentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        request.getParameterMap().forEach((k, v) -> System.out.println(k + " = " + java.util.Arrays.toString(v)));
        try {
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("user");
            if (customer == null) {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Please login again.\"}");
                return;
            }

            String dateStr = request.getParameter("appointmentTime"); // "2025-10-20  10:00 - 11:00"
            String note = request.getParameter("note");

            // Tách ngày và giờ bắt đầu
            String[] parts = dateStr.trim().split("\\s+");
            String datePart = parts[0];
            String sanitized = parts[1].replaceAll("[–—−]", "-");  // en dash, em dash, minus sign
            String startTimePart = sanitized.split("-")[0].trim();
            LocalDate date = LocalDate.parse(datePart);
            LocalTime startTime = LocalTime.parse(startTimePart);
            LocalDateTime appointmentDateTime = LocalDateTime.of(date, startTime);

            // Tạo appointment
            Appointment apm = new Appointment();
            apm.setCreationTime(LocalDateTime.now());
            apm.setAppointmentTime(appointmentDateTime);
            apm.setStatus("pending");
            apm.setNote(note);
            apm.setCustomer(customer);

            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.addAppointment(apm);

            if (success) {
                response.getWriter().write("{\"status\":\"success\",\"message\":\"Appointment booked successfully!\"}");
            } else {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to save appointment.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage().replace("\"","'") + "\"}");
        }
    }
}

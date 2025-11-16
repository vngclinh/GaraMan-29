package servlet;

import dao.AppointmentDAO;
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
            Appointment apm = (Appointment) session.getAttribute("appointment");

            if (customer == null || apm == null) {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Please login again.\"}");
                return;
            }

            apm.setCreationTime(LocalDateTime.now());
            apm.setStatus("pending");

            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.addAppointment(apm);

            if (success) {
                session.removeAttribute("appointment");

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

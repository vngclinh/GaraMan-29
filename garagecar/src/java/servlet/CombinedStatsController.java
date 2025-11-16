package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.ServiceStats;
import model.PartStats;
import dao.ServiceStatsDAO;
import dao.PartStatsDAO;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Comparator;

@WebServlet("/CombinedStatsController")
public class CombinedStatsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String start = request.getParameter("startDate");
            String end = request.getParameter("endDate");

            if (start != null && end != null && !start.isEmpty() && !end.isEmpty()) {
                Date startDate = Date.valueOf(start);
                Date endDate = Date.valueOf(end);

                ServiceStatsDAO servicedao = new ServiceStatsDAO();
                ArrayList<ServiceStats> servicestats = servicedao.getServiceStats(startDate, endDate);

                PartStatsDAO partdao = new PartStatsDAO();
                ArrayList<PartStats> partstats = partdao.getPartStats(startDate, endDate);

                if (servicestats != null) {
                    servicestats.sort(Comparator.comparingInt(ServiceStats::getId));
                }
                if (partstats != null) {
                    partstats.sort(Comparator.comparingInt(PartStats::getId));
                }
                request.setAttribute("serviceStats", servicestats);
                request.setAttribute("partStats", partstats);
            }

            RequestDispatcher rd = request.getRequestDispatcher("/staff/ServicePartStatsView.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading statistics: " + e.getMessage());
            request.getRequestDispatcher("/staff/ServicePartStatsView.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

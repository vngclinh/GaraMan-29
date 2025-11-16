package servlet;

import dao1.SystemUserDAO;
import model.SystemUser;
import model.Employee;
import model.Customer;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

public class SystemUserController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    username = username != null ? username.trim() : "";
    password = password != null ? password.trim() : "";

    SystemUserDAO userDAO = new SystemUserDAO();
    SystemUser user = null;
        String errorMessage = null;

        try {
            user = userDAO.checkLogin(username, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                if (user instanceof Employee) {
                    Employee emp = (Employee) user;
                    String position = emp.getPosition();
                    if (position != null && position.equalsIgnoreCase("managementstaff")) {
                        request.getRequestDispatcher("/staff/ManagerHomepage.jsp").forward(request, response);                    } 
                } else if (user instanceof Customer) {
                    request.getRequestDispatcher("/customer/CustomerHomepage.jsp").forward(request, response);                }
                return; 

            } else {
                errorMessage = "Wrong username or password";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("errorMessage", errorMessage);
        RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
        dispatcher.forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
    }
}
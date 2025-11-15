<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer" %>
<%
    // Lấy thông tin từ session và form trước đó
    Customer customer = (Customer) session.getAttribute("user");
    String name = (customer != null) ? customer.getFullname() : "Guest";
    String phone = (customer != null) ? customer.getPhoneNum() : "";

    String date = request.getParameter("date");
    String timeslot = request.getParameter("timeslot");
    String note = request.getParameter("note");

    String appointmentTime = "";
    if (date != null && timeslot != null) {
        appointmentTime = date.trim() + " " + timeslot.trim();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Confirmation - GaraMan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
            background: linear-gradient(135deg, #1a2a3a 0%, #2c3e50 100%);
            overflow-x: hidden;
        }

        /* Background with overlay */
        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('<%= request.getContextPath() %>/images/garage.jpg') no-repeat center center/cover;
            opacity: 0.3;
            z-index: -1;
        }

        /* Navbar */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background: rgba(10, 25, 47, 0.95);
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 40px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
            z-index: 100;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            padding: 10px 40px;
            background: rgba(10, 25, 47, 0.98);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo-icon {
            color: #3498db;
            font-size: 28px;
        }

        .logo h1 {
            margin: 0;
            font-size: 26px;
            letter-spacing: 1px;
            background: linear-gradient(to right, #3498db, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .navbar ul {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
            gap: 25px;
        }

        .navbar li {
            display: inline-block;
        }

        .navbar a {
            color: #ecf0f1;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .navbar a:hover {
            background: #3498db;
            color: white;
            transform: translateY(-2px);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 120px 20px 80px;
        }

        .confirmation-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 500px;
            position: relative;
            overflow: hidden;
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.8s ease forwards;
        }

        .confirmation-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        .confirmation-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .confirmation-icon {
            font-size: 50px;
            color: #3498db;
            margin-bottom: 15px;
        }

        h2 {
            margin-bottom: 10px;
            color: #2c3e50;
            font-size: 32px;
        }

        .confirmation-subtitle {
            color: #7f8c8d;
            font-size: 16px;
            margin-bottom: 5px;
        }

        /* Form Styles */
        .form-group {
            margin-bottom: 20px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease forwards;
        }

        .form-group:nth-child(1) { animation-delay: 0.2s; }
        .form-group:nth-child(2) { animation-delay: 0.3s; }
        .form-group:nth-child(3) { animation-delay: 0.4s; }
        .form-group:nth-child(4) { animation-delay: 0.5s; }

        label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
            font-size: 15px;
        }

        .input-with-icon {
            position: relative;
        }

        .input-with-icon i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            z-index: 1;
        }

        input[type="text"], textarea {
            display: block;
            width: 100%;
            padding: 12px 12px 12px 45px;
            border: 1px solid #bdc3c7;
            border-radius: 8px;
            font-size: 15px;
            outline: none;
            transition: all 0.3s;
            background: #f9f9f9;
            box-sizing: border-box;
            color: #2c3e50;
        }

        input[readonly], textarea[readonly] {
            background: #f5f5f5;
            color: #7f8c8d;
            cursor: not-allowed;
        }

        textarea {
            resize: none;
            height: 100px;
            padding-left: 15px;
        }

        .note-warning {
            color: #e74c3c;
            font-size: 13px;
            text-align: center;
            margin: 15px 0 25px;
            padding: 12px;
            background: #ffeaea;
            border-radius: 8px;
            border-left: 4px solid #e74c3c;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.6s forwards;
        }

        .note-warning i {
            margin-right: 5px;
        }

        .btn-container {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-top: 20px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.7s forwards;
        }

        .btn {
            flex: 1;
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-cancel {
            background: #95a5a6;
            color: white;
        }

        .btn-cancel:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .btn-confirm {
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: white;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
        }

        /* Footer */
        .footer {
            background: rgba(10, 25, 47, 0.9);
            color: #bdc3c7;
            text-align: center;
            padding: 20px;
            font-size: 14px;
        }

        /* Animations */
        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar {
                padding: 12px 20px;
                flex-direction: column;
                gap: 15px;
            }
            
            .navbar ul {
                gap: 15px;
            }
            
            .main-content {
                padding: 150px 15px 60px;
            }
            
            .confirmation-container {
                padding: 30px 25px;
            }
            
            .btn-container {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .confirmation-container {
                padding: 25px 20px;
            }
            
            h2 {
                font-size: 26px;
            }
        }
    </style>

    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        document.addEventListener("DOMContentLoaded", () => {
            const form = document.querySelector("form");

            form.addEventListener("submit", async (e) => {
                e.preventDefault();

                const formData = new FormData(form);

                for (const [k, v] of formData.entries()) {
                    console.log(k, "=", v);
                }

                const contextPath = "<%= request.getContextPath() %>";
                const response = await fetch(contextPath + "/AppointmentController", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: new URLSearchParams([...formData])
                });

                const result = await response.json();

                if (result.status === "success") {
                    alert("✅ " + result.message);
                    window.location.href = "CustomerHomepage.jsp";
                } else {
                    alert(result.message);
                }
            });
        });
    </script>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <div class="logo">
            <i class="fas fa-car-side logo-icon"></i>
            <h1>GaraMan</h1>
        </div>
        <ul>
            <li><a href="CustomerHomepage.jsp"><i class="fas fa-home"></i> Home</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-tools"></i> Services</a></li>
            <li><a href="BookAppointmentView.jsp"><i class="fas fa-calendar-check"></i> Book Appointment</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-history"></i> History</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-phone"></i> Contact</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="confirmation-container">
            <div class="confirmation-header">
                <div class="confirmation-icon">
                    <i class="fas fa-clipboard-check"></i>
                </div>
                <h2>Appointment Confirmation</h2>
                <p class="confirmation-subtitle">Please review your appointment details</p>
            </div>

            <form action="AppointmentController" method="POST">
                <div class="form-group">
                    <label for="customerName">Customer Name</label>
                    <div class="input-with-icon">
                        <i class="fas fa-user"></i>
                        <input type="text" id="customerName" name="customerName" value="<%= name %>" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <div class="input-with-icon">
                        <i class="fas fa-phone"></i>
                        <input type="text" id="phone" name="phone" value="<%= phone %>" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label for="appointmentTime">Appointment Time</label>
                    <div class="input-with-icon">
                        <i class="fas fa-calendar-alt"></i>
                        <input type="text" id="appointmentTime" name="appointmentTime" value="<%= appointmentTime %>" readonly>
                    </div>
                </div>

                <div class="form-group">
                    <label for="note">Additional Notes</label>
                    <textarea id="note" name="note" readonly><%= (note != null ? note : "") %></textarea>
                </div>

                <div class="note-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    Arrive within the timeslot you selected, otherwise the appointment will be canceled.
                </div>

                <div class="btn-container">
                    <button type="button" class="btn btn-cancel" onclick="window.location.href='BookAppointmentView.jsp'">
                        <i class="fas fa-arrow-left"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-confirm">
                        <i class="fas fa-check"></i> Confirm Appointment
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 GaraMan - Garage Car Management System. All rights reserved.
    </div>
</body>
</html>
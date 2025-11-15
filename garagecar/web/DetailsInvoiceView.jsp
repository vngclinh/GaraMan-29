<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Invoice, model.UsedService, model.UsedPart, model.ServiceTechstaff, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice Detail - GaraMan</title>
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
            padding: 12px 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
            z-index: 100;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            padding: 8px 30px;
            background: rgba(10, 25, 47, 0.98);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            color: #3498db;
            font-size: 24px;
        }

        .logo h1 {
            margin: 0;
            font-size: 22px;
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
            gap: 20px;
        }

        .navbar li {
            display: inline-block;
        }

        .navbar a {
            color: #ecf0f1;
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 6px;
            transition: all 0.3s;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
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
            padding: 80px 15px;
        }

        .invoice-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            position: relative;
            overflow: hidden;
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.8s ease forwards;
        }

        .invoice-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        /* Header Section */
        .invoice-header {
            text-align: center;
            margin-bottom: 25px;
            border-bottom: 2px solid #ecf0f1;
            padding-bottom: 20px;
        }

        .invoice-icon {
            font-size: 40px;
            color: #3498db;
            margin-bottom: 10px;
        }

        h2 {
            margin-bottom: 5px;
            color: #2c3e50;
            font-size: 28px;
        }

        .invoice-subtitle {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 0;
        }

        /* Customer Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.2s forwards;
        }

        .info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #3498db;
        }

        .info-card h3 {
            margin: 0 0 15px 0;
            color: #2c3e50;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-card h3 i {
            color: #3498db;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e9ecef;
        }

        .info-label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 14px;
        }

        .info-value {
            color: #7f8c8d;
            font-size: 14px;
            text-align: right;
        }

        /* Tables Section */
        .tables-section {
            margin-bottom: 25px;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            color: #2c3e50;
            font-size: 18px;
            font-weight: 600;
        }

        .section-header i {
            color: #3498db;
        }

        /* Fixed Size Table Containers */
        .table-container {
            height: 200px;
            overflow-y: auto;
            border: 1px solid #e1e8ed;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.4s forwards;
        }

        .table-container:nth-child(2) {
            animation-delay: 0.5s;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
            font-size: 14px;
            height: 50px;
            vertical-align: middle;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
            position: sticky;
            top: 0;
            z-index: 10;
            border-bottom: 2px solid #3498db;
        }

        /* Fixed column widths */
        .services-table th:nth-child(1), .services-table td:nth-child(1) { width: 60px; } /* No */
        .services-table th:nth-child(2), .services-table td:nth-child(2) { width: auto; } /* Name */
        .services-table th:nth-child(3), .services-table td:nth-child(3) { width: 300px; text-align: center } /* Technical Staffs */
        .services-table th:nth-child(4), .services-table td:nth-child(4) { width: 200px; text-align: right; } /* Unit Price */
        .services-table th:nth-child(5), .services-table td:nth-child(5) { width: 80px; text-align: center; } /* Quantity */
        .services-table th:nth-child(6), .services-table td:nth-child(6) { width: 200px; text-align: right; } /* Item Total */

        .parts-table th:nth-child(1), .parts-table td:nth-child(1) { width: 60px; } /* No */
        .parts-table th:nth-child(2), .parts-table td:nth-child(2) { width: auto; } /* Name */
        .parts-table th:nth-child(3), .parts-table td:nth-child(3) { width: 200px; text-align: right; } /* Unit Price */
        .parts-table th:nth-child(4), .parts-table td:nth-child(4) { width: 80px; text-align: center; } /* Quantity */
        .parts-table th:nth-child(5), .parts-table td:nth-child(5) { width: 200px; text-align: right; } /* Item Total */

        tbody tr {
            transition: all 0.2s ease;
            height: 50px;
        }

        tbody tr:hover {
            background: #f1f8ff;
        }

        .money {
            text-align: right;
            font-weight: 600;
            color: #27ae60;
        }

        .empty-row {
            text-align: center;
            color: #7f8c8d;
            font-style: italic;
            height: 50px;
        }

        .empty-row td {
            border-bottom: 1px solid #ecf0f1;
            vertical-align: middle;
        }

        /* Totals Section */
        .totals-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.6s forwards;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e9ecef;
        }

        .total-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
            font-weight: 700;
            font-size: 16px;
            color: #2c3e50;
        }

        .total-label {
            font-weight: 600;
            color: #2c3e50;
        }

        .total-value {
            font-weight: 600;
            color: #27ae60;
        }

        .discount-value {
            color: #e74c3c;
        }

        /* Button Container */
        .btn-container {
            display: flex;
            justify-content: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.7s forwards;
        }

        .btnBack {
            background: #95a5a6;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btnBack:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        /* Error Message */
        .error-message {
            text-align: center;
            color: #e74c3c;
            background: #ffeaea;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #e74c3c;
            margin: 20px 0;
        }

        /* Custom Scrollbar */
        .table-container::-webkit-scrollbar {
            width: 8px;
        }

        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 0 10px 10px 0;
        }

        .table-container::-webkit-scrollbar-thumb {
            background: #3498db;
            border-radius: 8px;
        }

        .table-container::-webkit-scrollbar-thumb:hover {
            background: #2980b9;
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
                padding: 10px 15px;
                flex-direction: column;
                gap: 10px;
            }
            
            .navbar ul {
                gap: 10px;
            }
            
            .main-content {
                padding: 100px 8px;
            }
            
            .invoice-container {
                padding: 20px 15px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .table-container {
                height: 180px;
            }
            
            th, td {
                padding: 10px 12px;
                font-size: 13px;
                height: 45px;
            }
            
            /* Adjust column widths for mobile */
            .services-table th:nth-child(2), .services-table td:nth-child(2) { width: 150px; }
            .services-table th:nth-child(6), .services-table td:nth-child(6) { width: 120px; }
        }

        @media (max-width: 480px) {
            h2 {
                font-size: 24px;
            }
            
            .invoice-icon {
                font-size: 32px;
            }
            
            .table-container {
                height: 160px;
            }
            
            th, td {
                padding: 8px 10px;
                font-size: 12px;
                height: 40px;
            }
        }

        /* Footer */
        .footer {
            background: rgba(10, 25, 47, 0.9);
            color: #bdc3c7;
            text-align: center;
            padding: 15px;
            font-size: 13px;
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
            <li><a href="ManagerHomepage.jsp"><i class="fas fa-home"></i> Home</a></li>
            <li><a href="SelectStatsView.jsp"><i class="fas fa-chart-line"></i> Analytics</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-users"></i> Staff</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-cogs"></i> Settings</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="invoice-container">
            <%
                Invoice inv = (Invoice) request.getAttribute("invoice");
                if (inv != null) {
            %>

            <!-- Header -->
            <div class="invoice-header">
                <h2>Invoice Details</h2>
            </div>

            <!-- Customer Information -->
            <div class="info-grid">
                <div class="info-card">
                    <h3><i class="fas fa-user"></i> Customer Information</h3>
                    <div class="info-row">
                        <span class="info-label">Customer Name:</span>
                        <span class="info-value"><%= inv.getCustomer().getFullname() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phone Number:</span>
                        <span class="info-value"><%= inv.getCustomer().getPhoneNum() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Address:</span>
                        <span class="info-value"><%= inv.getCustomer().getAddress() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Car Plate:</span>
                        <span class="info-value"><%= inv.getCar() != null ? inv.getCar().getPlateNum() : "N/A" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Car Name:</span>
                        <span class="info-value"><%= inv.getCar() != null ? inv.getCar().getName() : "N/A" %></span>
                    </div>
                </div>

                <div class="info-card">
                    <h3><i class="fas fa-info-circle"></i> Invoice Information</h3>
                    <div class="info-row">
                        <span class="info-label">Created At:</span>
                        <span class="info-value">
                            <%= inv.getCreationTime().toLocalTime().withSecond(0).toString() %> 
                            <%= inv.getCreationTime().toLocalDate().toString() %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Payment Date:</span>
                        <span class="info-value">
                            <%= inv.getPayment() != null && inv.getPayment().getDate() != null 
                                ? inv.getPayment().getDate().toLocalTime().withSecond(0).toString() + " " + inv.getPayment().getDate().toLocalDate().toString()
                                : "N/A"
                            %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Payment method:</span>
                        <span class="info-value"><%= inv.getPayment().getMethod() %></span>
                    </div>                    <div class="info-row">
                        <span class="info-label">Sales Staff:</span>
                        <span class="info-value"><%= inv.getStaff() != null ? inv.getStaff().getFullname() : "N/A" %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Status:</span>
                        <span class="info-value"><%= inv.getStatus() != null ? inv.getStatus() : "N/A" %></span>
                    </div>
                </div>
            </div>

            <!-- Services Table -->
            <div class="tables-section">
                <div class="section-header">
                    <i class="fas fa-tools"></i>
                    <span>List of Services</span>
                </div>
                <div class="table-container">
                    <table class="services-table">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>Name</th>
                                <th>Technical Staffs</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th>Item Total</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<UsedService> services = inv.getListService();
                            if (services != null && !services.isEmpty()) {
                                int idx = 1;
                                for (UsedService us : services) {
                                    float itemTotal = us.getUnitPrice() * us.getQuantity();

                                    // Lấy danh sách kỹ thuật viên
                                    StringBuilder techs = new StringBuilder();
                                    if (us.getListTechstaff() != null && !us.getListTechstaff().isEmpty()) {
                                        for (int i = 0; i < us.getListTechstaff().size(); i++) {
                                            ServiceTechstaff st = us.getListTechstaff().get(i);
                                            if (st.getTechnician() != null) {
                                                techs.append(st.getTechnician().getFullname());
                                                if (i < us.getListTechstaff().size() - 1)
                                                    techs.append(", ");
                                            }
                                        }
                                    } else {
                                        techs.append("-");
                                    }
                        %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><%= us.getService().getName() %></td>
                                <td><%= techs.toString() %></td>
                                <td class="money"><%= String.format("%,.0f VND", us.getUnitPrice()) %></td>
                                <td><%= us.getQuantity() %></td>
                                <td class="money"><%= String.format("%,.0f VND", itemTotal) %></td>
                            </tr>
                        <%      }
                            } else { %>
                            <tr class="empty-row">
                                <td colspan="6">No services used</td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Parts Table -->
            <div class="tables-section">
                <div class="section-header">
                    <i class="fas fa-cogs"></i>
                    <span>List of Parts</span>
                </div>
                <div class="table-container">
                    <table class="parts-table">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>Name</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th>Item Total</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<UsedPart> parts = inv.getListPart();
                            if (parts != null && !parts.isEmpty()) {
                                int idx = 1;
                                for (UsedPart up : parts) {
                                    float itemTotal = up.getUnitPrice() * up.getQuantity();
                        %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><%= up.getPart().getName() %></td>
                                <td class="money"><%= String.format("%,.0f VND", up.getUnitPrice()) %></td>
                                <td><%= up.getQuantity() %></td>
                                <td class="money"><%= String.format("%,.0f VND", itemTotal) %></td>
                            </tr>
                        <%      }
                            } else { %>
                            <tr class="empty-row">
                                <td colspan="5">No parts used</td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Totals Section -->
            <div class="totals-section">
                <%
                    float total = inv.getTotal();
                %>
                <div class="total-row">
                    <span class="total-label">Total Amount:</span>
                    <span class="total-value"><%= String.format("%,.0f VND", total) %></span>
                </div>
            </div>

            <!-- Back Button -->
            <div class="btn-container">
                <button class="btnBack" onclick="window.history.back()">
                    <i class="fas fa-arrow-left"></i> Back to Invoice List
                </button>
            </div>

            <% } else { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    Invoice not found
                </div>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 GaraMan - Garage Car Management System. All rights reserved.
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder, java.util.*, model.ServiceStats, model.PartStats" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service & Part Statistics - GaraMan</title>
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

        /* Main Content - Reduced padding */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 80px 15px 40px;
        }

        .stats-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 1800px;
            margin: 0 auto;
            position: relative;
            overflow: hidden;
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.8s ease forwards;
        }

        .stats-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        /* Compact Header */
        .stats-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .stats-icon {
            font-size: 36px;
            color: #3498db;
            margin-bottom: 8px;
        }

        h2 {
            margin-bottom: 5px;
            color: #2c3e50;
            font-size: 26px;
        }

        .stats-subtitle {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 0;
        }

        /* Compact Filter Form */
        .filter-form {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.2s forwards;
        }

        .form-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 14px;
            white-space: nowrap;
        }

        input[type="date"] {
            padding: 8px 10px;
            border: 1px solid #bdc3c7;
            border-radius: 6px;
            font-size: 13px;
            outline: none;
            transition: all 0.3s;
            width: 140px;
        }

        input[type="date"]:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        .btn {
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.3);
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
        }

        /* Full Width Tables Layout */
        .tables-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .table-section {
            background: white;
            border-radius: 10px;
            padding: 0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.4s forwards;
        }

        .table-section:nth-child(2) {
            animation-delay: 0.5s;
        }

        .section-header {
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: white;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 16px;
            font-weight: 600;
        }

        .section-header i {
            font-size: 16px;
        }

        .table-wrapper {
            max-height: 400px;
            overflow-y: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        th, td {
            padding: 10px 12px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
            font-size: 14px;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        th:nth-child(1), td:nth-child(1) { width: 80px; } /* ID */
        th:nth-child(2), td:nth-child(2) { width: auto; } /* Name */
        th:nth-child(3), td:nth-child(3) { width: 150px; text-align: center} /* Quantity */
        th:nth-child(4), td:nth-child(4) { width: 150px; text-align: right} /* Revenue */

        tbody tr {
            transition: all 0.2s ease;
            cursor: pointer;
            height: 40px;
        }

        tbody tr:hover {
            background: #f1f8ff;
        }

        .revenue {
            text-align: right;
            font-weight: 600;
            color: #27ae60;
        }

        .empty-row {
            text-align: center;
            color: #7f8c8d;
            font-style: italic;
            padding: 20px;
        }

        .empty-row td {
            border-bottom: none;
        }

        .totals-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 15px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.6s forwards;
        }

        .total-card {
            background: white;
            border-radius: 10px;
            padding: 15px 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .total-card.service {
            border-top: 3px solid #3498db;
        }

        .total-card.part {
            border-top: 3px solid #e74c3c;
        }

        .total-label {
            font-size: 14px;
            color: #7f8c8d;
            margin-bottom: 5px;
        }

        .total-value {
            font-size: 20px;
            font-weight: 700;
            color: #2c3e50;
        }

        .service .total-value {
            color: #3498db;
        }

        .part .total-value {
            color: #e74c3c;
        }

        .overall-total {
            background: linear-gradient(135deg, #3498db, #2ecc71);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 15px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.7s forwards;
        }

        .overall-label {
            font-size: 14px;
            margin-bottom: 5px;
            opacity: 0.9;
        }

        .overall-value {
            font-size: 24px;
            font-weight: 700;
        }

        /* Compact Button Container */
        .btn-container {
            display: flex;
            justify-content: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.8s forwards;
        }

        .back-btn {
            background: #95a5a6;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .back-btn:hover {
            background: #7f8c8d;
            transform: translateY(-1px);
        }

        /* Error Message */
        .error {
            background: #ffeaea;
            color: #e74c3c;
            padding: 12px;
            border-radius: 6px;
            text-align: center;
            margin-top: 15px;
            border-left: 3px solid #e74c3c;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease forwards;
            font-size: 13px;
        }

        /* Animations */
        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive */
        @media (max-width: 1400px) {
            .main-content {
                padding: 80px 10px 30px;
            }
            
            .stats-container {
                padding: 20px;
            }
        }

        @media (max-width: 1200px) {
            .tables-container, .totals-container {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .table-wrapper {
                max-height: 300px;
            }
        }

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
                padding: 100px 8px 25px;
            }
            
            .stats-container {
                padding: 15px;
            }
            
            .filter-form {
                flex-direction: column;
                align-items: stretch;
                gap: 10px;
                padding: 12px 15px;
            }
            
            .form-group {
                justify-content: space-between;
            }
            
            input[type="date"] {
                width: 120px;
            }
            
            th, td {
                padding: 8px 10px;
                font-size: 14px;
            }
            
            .section-header {
                padding: 10px 15px;
                font-size: 14px;
            }
        }

        @media (max-width: 480px) {
            h2 {
                font-size: 22px;
            }
            
            .stats-icon {
                font-size: 30px;
            }
            
            .total-value, .overall-value {
                font-size: 18px;
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

        // Set default dates to current month
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
            
            const startDateInput = document.querySelector('input[name="startDate"]');
            const endDateInput = document.querySelector('input[name="endDate"]');
            
            // Format dates as YYYY-MM-DD
            const formatDate = (date) => {
                return date.toISOString().split('T')[0];
            };
            
            if (!startDateInput.value) {
                startDateInput.value = formatDate(firstDay);
            }
            if (!endDateInput.value) {
                endDateInput.value = formatDate(today);
            }
        });
        function sortBothTables(order) {
            if (!order) return;

            const tables = document.querySelectorAll('.table-section table');

            tables.forEach(table => {
                const rows = Array.from(table.querySelectorAll('tbody tr')).filter(
                    r => !r.classList.contains('empty-row')
                );

                rows.sort((a, b) => {
                    const va = parseFloat(a.querySelector('.revenue').textContent.replace(/[^\d.-]/g, ''));
                    const vb = parseFloat(b.querySelector('.revenue').textContent.replace(/[^\d.-]/g, ''));
                    return order === 'asc' ? va - vb : vb - va;
                });

                const tbody = table.querySelector('tbody');
                tbody.innerHTML = '';
                rows.forEach(r => tbody.appendChild(r));
            });
        }
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
        <div class="stats-container">
            <!-- Compact Header -->
            <div class="stats-header">
                <div class="stats-icon">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <h2>Service & Part Statistics</h2>
                <p class="stats-subtitle">Analyze revenue performance by services and parts</p>
            </div>

            <!-- Compact Filter Form -->
            <form method="get" action="CombinedStatsController" class="filter-form">
                <div class="form-group">
                    <label for="startDate"><i class="fas fa-calendar-alt"></i> Start Date</label>
                    <input type="date" id="startDate" name="startDate" required value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="endDate"><i class="fas fa-calendar-alt"></i> End Date</label>
                    <input type="date" id="endDate" name="endDate" required value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>">
                </div>
                <div class="form-group">
                    <label for="sortRevenue"><i class="fas fa-sort-amount-up-alt"></i> Sort by Revenue</label>
                    <select id="sortRevenue" onchange="sortBothTables(this.value)">
                        <option value="">-- None --</option>
                        <option value="asc">Ascending</option>
                        <option value="desc">Descending</option>
                    </select>
                </div>
                
                <button type="submit" class="btnView">
                    <i class="fas fa-chart-line"></i> View Statistics
                </button>
            </form>

            <%
                List<ServiceStats> serviceStats = (List<ServiceStats>) request.getAttribute("serviceStats");
                List<PartStats> partStats = (List<PartStats>) request.getAttribute("partStats");
                float totalService = 0, totalPart = 0;
                String startParam = request.getParameter("startDate");
                String endParam = request.getParameter("endDate");
            %>

            <!-- Full Width Tables -->
            <div class="tables-container">
                <!-- Services Table -->
                <div class="table-section">
                    <div class="section-header">
                        <i class="fas fa-tools"></i>
                        Service Statistics
                    </div>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Service Name</th>
                                    <th>Provided Quantity</th>
                                    <th class="revenue">Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (serviceStats != null && !serviceStats.isEmpty()) { 
                                    for (ServiceStats s : serviceStats) {
                                        totalService += s.getTotalRevenue();
                                        String encodedName = URLEncoder.encode(s.getName(), "UTF-8");
                                %>
                                    <tr onclick="window.location.href='InvoiceController?type=service&id=<%= s.getId() %>&name=<%= encodedName %>&start=<%= startParam %>&end=<%= endParam %>'">
                                        <td><%= s.getId() %></td>
                                        <td><%= s.getName() %></td>
                                        <td><%= s.getTotalQuantity() %></td>
                                        <td class="revenue"><%= String.format("%,.0f VND", s.getTotalRevenue()) %></td>
                                    </tr>
                                <% } 
                                } else { %>
                                    <tr class="empty-row">
                                        <td colspan="4">No service data available for the selected period</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Parts Table -->
                <div class="table-section">
                    <div class="section-header">
                        <i class="fas fa-cogs"></i>
                        Part Statistics
                    </div>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Part Name</th>
                                    <th>Provided Quantity</th>
                                    <th class="revenue">Revenue</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (partStats != null && !partStats.isEmpty()) { 
                                    for (PartStats p : partStats) {
                                        totalPart += p.getTotalRevenue();
                                        String encodedName = URLEncoder.encode(p.getName(), "UTF-8");
                                %>
                                    <tr onclick="window.location.href='InvoiceController?type=part&id=<%= p.getId() %>&name=<%= encodedName %>&start=<%= startParam %>&end=<%= endParam %>'">
                                        <td><%= p.getId() %></td>
                                        <td><%= p.getName() %></td>
                                        <td><%= p.getTotalQuantity() %></td>
                                        <td class="revenue"><%= String.format("%,.0f VND", p.getTotalRevenue()) %></td>
                                    </tr>
                                <% } 
                                } else { %>
                                    <tr class="empty-row">
                                        <td colspan="4">No part data available for the selected period</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Compact Totals Section -->
            <% if ((serviceStats != null && !serviceStats.isEmpty()) || (partStats != null && !partStats.isEmpty())) { %>
                <div class="totals-container">
                    <div class="total-card service">
                        <div class="total-label">Total Service Revenue</div>
                        <div class="total-value"><%= String.format("%,.0f VND", totalService) %></div>
                    </div>
                    <div class="total-card part">
                        <div class="total-label">Total Part Revenue</div>
                        <div class="total-value"><%= String.format("%,.0f VND", totalPart) %></div>
                    </div>
                </div>

                <div class="overall-total">
                    <div class="overall-label">Overall Total Revenue</div>
                    <div class="overall-value"><%= String.format("%,.0f VND", (totalService + totalPart)) %></div>
                </div>
            <% } %>

            <!-- Compact Back Button -->
            <div class="btn-container">
                <button class="back-btn" onclick="window.location.href='SelectStatsView.jsp'">
                    <i class="fas fa-arrow-left"></i> Back to Statistics
                </button>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
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
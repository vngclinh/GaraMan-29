<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Invoice, model.UsedService, model.UsedPart" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice List - GaraMan</title>
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

        /* Main Content - Equal spacing */
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 80px 15px;
        }

        .invoices-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
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

        .invoices-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        /* Header Section */
        .invoices-header {
            text-align: center;
            margin-bottom: 20px;
        }

        .invoices-icon {
            font-size: 36px;
            color: #3498db;
            margin-bottom: 8px;
        }

        h2 {
            margin-bottom: 5px;
            color: #2c3e50;
            font-size: 26px;
        }

        .invoices-subtitle {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 0;
        }

        .filter-info {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.2s forwards;
        }

        .filter-info strong {
            color: #3498db;
            font-weight: 600;
        }

        /* Fixed Size Table Container */
        .table-container {
            height: 550px; /* Fixed height */
            overflow-y: auto;
            border: 1px solid #e1e8ed;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.4s forwards;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed; /* Fixed table layout */
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
            font-size: 14px;
            height: 50px; /* Fixed row height */
            vertical-align: middle;
        }

        th {
            background: #3498db;
            font-weight: 600;
            color: #2c3e50;
            position: sticky;
            top: 0;
            z-index: 10;
            border-bottom: 2px solid #3498db;
        }

        /* Fixed column widths - same as previous page */
        th:nth-child(1), td:nth-child(1) { width: 100px; } /* ID */
        th:nth-child(2), td:nth-child(2) { width: 120px; text-align:center; } /* Date */
        th:nth-child(3), td:nth-child(3) { width: auto; text-align:center;} /* Customer Name */
        th:nth-child(4), td:nth-child(4) { width: 120px; text-align: center; }   /* Item Quantity */
        th:nth-child(5), td:nth-child(5) { width: 150px; text-align: right; }    /* Unit Price */
        th:nth-child(6), td:nth-child(6) { width: 150px; text-align: right; }    /* Total Item */
        th:nth-child(7), td:nth-child(7) { width: 150px; text-align: right; }    /* Total Bill */
        th:nth-child(8), td:nth-child(8) { width: 120px; text-align: center; }   /* Status */


        tbody tr {
            transition: all 0.2s ease;
            cursor: pointer;
            height: 50px; /* Fixed row height */
        }

        tbody tr:hover {
            background: #f1f8ff;
        }

        .total {
            text-align: right;
            font-weight: 600;
            color: #27ae60;
        }

        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
            display: inline-block;
            min-width: 80px;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        /* Empty state with fixed height rows */
        .empty-row {
            text-align: center;
            color: #7f8c8d;
            font-style: italic;
            height: 50px; /* Same fixed height as other rows */
        }

        .empty-row td {
            border-bottom: 1px solid #ecf0f1; /* Keep border for consistency */
            vertical-align: middle;
        }

        /* Button Container */
        .btn-container {
            display: flex;
            justify-content: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.6s forwards;
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

        /* Custom Scrollbar */
        .table-container::-webkit-scrollbar {
            width: 8px;
        }

        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 0 10px 10px 0;
        }

        .table-container::-webkit-scrollbar-thumb {
            background: white;
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
            
            .invoices-container {
                padding: 20px 15px;
            }
            
            .table-container {
                height: 350px;
            }
            
            th, td {
                padding: 10px 12px;
                font-size: 13px;
                height: 45px;
            }
            
            /* Adjust column widths for mobile */
            th:nth-child(1), td:nth-child(1) { width: 80px; }
            th:nth-child(2), td:nth-child(2) { width: 100px; }
            th:nth-child(4), td:nth-child(4) { width: 120px; }
            th:nth-child(5), td:nth-child(5) { width: 100px; }
            
            tbody tr {
                height: 45px;
            }
            
            .empty-row {
                height: 45px;
            }
        }

        @media (max-width: 480px) {
            h2 {
                font-size: 22px;
            }
            
            .invoices-icon {
                font-size: 30px;
            }
            
            .filter-info {
                padding: 12px 15px;
                font-size: 13px;
            }
            
            .table-container {
                height: 300px;
            }
            
            th, td {
                padding: 8px 10px;
                font-size: 12px;
                height: 40px;
            }
            
            tbody tr {
                height: 40px;
            }
            
            .empty-row {
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

        // Add status badge styling based on status text
        document.addEventListener('DOMContentLoaded', function() {
            const statusCells = document.querySelectorAll('td:nth-child(5)');
            statusCells.forEach(cell => {
                const status = cell.textContent.trim().toLowerCase();
                if (status.includes('complete') || status.includes('done') || status.includes('finished')) {
                    cell.innerHTML = '<span class="status status-completed">' + cell.textContent + '</span>';
                } else if (status.includes('pending') || status.includes('processing') || status.includes('waiting')) {
                    cell.innerHTML = '<span class="status status-pending">' + cell.textContent + '</span>';
                } else if (status.includes('cancel') || status.includes('reject') || status.includes('failed')) {
                    cell.innerHTML = '<span class="status status-cancelled">' + cell.textContent + '</span>';
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
            <li><a href="ManagerHomepage.jsp"><i class="fas fa-home"></i> Home</a></li>
            <li><a href="SelectStatsView.jsp"><i class="fas fa-chart-line"></i> Analytics</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-users"></i> Staff</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-cogs"></i> Settings</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content with equal spacing -->
    <div class="main-content">
        <div class="invoices-container">
            <!-- Header -->
            <div class="invoices-header">
                <div class="invoices-icon">
                    <i class="fas fa-file-invoice"></i>
                </div>
                <h2>Invoice List</h2>
                <p class="invoices-subtitle">Detailed view of all invoices</p>
            </div>

            <!-- Filter Information -->
            <div class="filter-info">
                <i class="fas fa-filter"></i>
                Showing invoices containing <strong><%= request.getAttribute("itemName") %></strong>
                between <strong><%= request.getAttribute("start") %></strong> and <strong><%= request.getAttribute("end") %></strong>
            </div>

            <!-- Fixed Size Table Container -->
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date</th>
                            <th>Customer Name</th>
                            <th>Item Quantity</th>
                            <th>Item Unit Price</th>
                            <th>Total Item</th>
                            <th>Total Bill</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Invoice> list = (List<Invoice>) request.getAttribute("invoiceList");
                        Map<Integer, Object> itemMap = (Map<Integer, Object>) request.getAttribute("itemMap");

                            for (Invoice inv : list) {
                                Object item = itemMap.get(inv.getId());
                                int qty = 0;
                                float unit = 0;
                                float totalItem = 0;

                                if (item != null) {
                                    if (item instanceof UsedPart) {
                                        UsedPart up = (UsedPart) item;
                                        qty = up.getQuantity();
                                        unit = up.getUnitPrice();
                                        totalItem = qty * unit;
                                    } else if (item instanceof UsedService) {
                                        UsedService us = (UsedService) item;
                                        qty = us.getQuantity();
                                        unit = us.getUnitPrice();
                                        totalItem = qty * unit;
                                    }
                                }
                    %>
                        <tr onclick="window.location.href='InvoiceController?invoiceId=<%=inv.getId()%>'">
                            <td><%=inv.getId()%></td>
                            <td><%=inv.getCreationTime().toLocalDate()%></td>
                            <td><%=inv.getCustomer().getFullname()%></td>
                            <td style="text-align:center;"><%=qty%></td>
                            <td style="text-align:right;"><%=String.format("%,.0f VND", unit)%></td>
                            <td style="text-align:right; color:#2980b9;"><%=String.format("%,.0f VND", totalItem)%></td>
                            <td class="total"><%=String.format("%,.0f VND", inv.getTotal())%></td>
                            <td><%=inv.getStatus()%></td>
                        </tr>
                    <%
                            }
                    %>
                        <tr class="empty-row">
                            <td colspan="8"></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Back Button -->
            <div class="btn-container">
                <button class="btnBack" onclick="window.history.back()">
                    <i class="fas fa-arrow-left"></i> Back to Statistics
                </button>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 GaraMan - Garage Car Management System. All rights reserved.
    </div>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Employee" %>
<%
    Employee emp = (Employee) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Homepage - GaraMan</title>
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

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ecf0f1;
        }

        .user-info i {
            color: #3498db;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 120px 20px 80px;
            text-align: center;
        }

        .welcome-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            max-width: 800px;
            width: 100%;
            position: relative;
            overflow: hidden;
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.8s ease forwards;
        }

        .welcome-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        .welcome-header {
            margin-bottom: 30px;
        }

        .welcome-icon {
            font-size: 50px;
            color: #3498db;
            margin-bottom: 20px;
        }

        h2 {
            margin-bottom: 10px;
            color: #2c3e50;
            font-size: 32px;
        }

        .welcome-subtitle {
            color: #7f8c8d;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .manager-name {
            color: #3498db;
            font-weight: 600;
            font-size: 24px;
        }

        .role-badge {
            display: inline-block;
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-top: 5px;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 25px;
            margin-top: 40px;
            flex-wrap: wrap;
        }

        .action-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: white;
            border: none;
            border-radius: 12px;
            padding: 25px 20px;
            width: 200px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0;
            transform: translateY(20px);
            text-decoration: none;
            color: inherit;
        }

        .action-btn:nth-child(1) {
            animation: fadeInUp 0.8s ease 0.3s forwards;
        }

        .action-btn:nth-child(2) {
            animation: fadeInUp 0.8s ease 0.5s forwards;
        }

        .action-btn:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.15);
        }

        .stats-btn {
            border-top: 4px solid #3498db;
        }

        .manage-btn {
            border-top: 4px solid #e74c3c;
        }

        .btn-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }

        .stats-btn .btn-icon {
            color: #3498db;
        }

        .manage-btn .btn-icon {
            color: #e74c3c;
        }

        .btn-text {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .btn-desc {
            font-size: 14px;
            color: #7f8c8d;
            line-height: 1.4;
        }

        /* Dashboard Section */
        .dashboard-section {
            margin-top: 60px;
            width: 100%;
            max-width: 1000px;
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.8s ease 0.7s forwards;
        }

        .section-title {
            color: white;
            font-size: 28px;
            margin-bottom: 30px;
            text-align: center;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
        }

        .dashboard-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 12px;
            padding: 25px 20px;
            text-align: center;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }

        .card-icon {
            font-size: 36px;
            color: #3498db;
            margin-bottom: 15px;
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .card-desc {
            font-size: 14px;
            color: #7f8c8d;
            line-height: 1.5;
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
            
            .welcome-container {
                padding: 30px 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .action-btn {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>

    <script>
        function showUnderConstruction(event) {
            event.preventDefault();
            alert("🚧 This function is under construction 🚧");
        }
        
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
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-home"></i> Home</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-chart-line"></i> Analytics</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-users"></i> Staff</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-cogs"></i> Settings</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
        <div class="user-info">
            <i class="fas fa-user-tie"></i>
            <span>
                <%= emp != null ? emp.getFullname() : "Unknown" %>
            </span>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Welcome Section -->
        <div class="welcome-container">
            <div class="welcome-header">
                <div class="welcome-icon">
                    <i class="fas fa-user-tie"></i>
                </div>
                <h2>Manager Homepage</h2>
                <p class="welcome-subtitle">Welcome back,</p>
                <p class="manager-name"><%= emp != null ? emp.getFullname() : "Unknown" %></p>
                <div class="role-badge">Management Staff</div>
                <p class="welcome-subtitle">Manage your garage operations efficiently</p>
            </div>

            <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/staff/SelectStatsView.jsp" class="action-btn stats-btn">
                    <i class="fas fa-chart-bar btn-icon"></i>
                    <div class="btn-text">View Statistics</div>
                    <div class="btn-desc">Analyze business performance and reports</div>
                </a>
                <a href="#" class="action-btn manage-btn" onclick="showUnderConstruction(event)">
                    <i class="fas fa-cog btn-icon"></i>
                    <div class="btn-text">Manage Information</div>
                    <div class="btn-desc">Update system settings and data</div>
                </a>
            </div>
        </div>

        <!-- Dashboard Section -->
        <div class="dashboard-section">
            <h3 class="section-title">Quick Access</h3>
            <div class="dashboard-grid">
                <div class="dashboard-card" onclick="showUnderConstruction(event)">
                    <i class="fas fa-calendar-check card-icon"></i>
                    <div class="card-title">Appointments</div>
                    <div class="card-desc">View and manage customer appointments</div>
                </div>
                <div class="dashboard-card" onclick="showUnderConstruction(event)">
                    <i class="fas fa-tools card-icon"></i>
                    <div class="card-title">Services</div>
                    <div class="card-desc">Manage service offerings and pricing</div>
                </div>
                <div class="dashboard-card" onclick="showUnderConstruction(event)">
                    <i class="fas fa-users card-icon"></i>
                    <div class="card-title">Customers</div>
                    <div class="card-desc">View customer database and history</div>
                </div>
                <div class="dashboard-card" onclick="showUnderConstruction(event)">
                    <i class="fas fa-file-invoice card-icon"></i>
                    <div class="card-title">Reports</div>
                    <div class="card-desc">Generate business reports and insights</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        &copy; 2025 GaraMan - Garage Car Management System. All rights reserved.
    </div>
</body>
</html>
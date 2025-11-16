<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Statistics - GaraMan</title>
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

        .stats-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 600px;
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
            height: 5px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        .stats-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .stats-icon {
            font-size: 50px;
            color: #3498db;
            margin-bottom: 15px;
        }

        h2 {
            margin-bottom: 10px;
            color: #2c3e50;
            font-size: 32px;
        }

        .stats-subtitle {
            color: #7f8c8d;
            font-size: 16px;
            margin-bottom: 5px;
        }

        /* Stats Options */
        .stats-options {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 30px;
        }

        .stats-option {
            background: white;
            border: none;
            border-radius: 12px;
            padding: 20px 25px;
            text-align: left;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 20px;
            opacity: 0;
            transform: translateY(20px);
            text-decoration: none;
            color: inherit;
        }

        .stats-option:nth-child(1) { animation: fadeInUp 0.8s ease 0.2s forwards; }
        .stats-option:nth-child(2) { animation: fadeInUp 0.8s ease 0.3s forwards; }
        .stats-option:nth-child(3) { animation: fadeInUp 0.8s ease 0.4s forwards; }

        .stats-option:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .option-active {
            border-left: 5px solid #3498db;
        }

        .option-inactive {
            border-left: 5px solid #e74c3c;
            opacity: 0.8;
        }

        .option-icon {
            font-size: 32px;
            width: 50px;
            text-align: center;
        }

        .option-active .option-icon {
            color: #3498db;
        }

        .option-inactive .option-icon {
            color: #e74c3c;
        }

        .option-content {
            flex: 1;
        }

        .option-title {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .option-desc {
            font-size: 14px;
            color: #7f8c8d;
            line-height: 1.4;
        }

        .option-badge {
            display: inline-block;
            background: #2ecc71;
            color: white;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-left: 10px;
        }

        .option-inactive .option-badge {
            background: #e74c3c;
        }

        /* Button Container */
        .btn-container {
            display: flex;
            justify-content: center;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.5s forwards;
        }

        .back-btn {
            background: #95a5a6;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
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
            
            .stats-container {
                padding: 30px 25px;
            }
            
            .stats-option {
                padding: 15px 20px;
            }
        }

        @media (max-width: 480px) {
            .stats-container {
                padding: 25px 20px;
            }
            
            h2 {
                font-size: 26px;
            }
            
            .stats-option {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
            
            .option-icon {
                width: auto;
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
            <li><a href="<%= request.getContextPath() %>/staff/ManagerHomepage.jsp"><i class="fas fa-home"></i> Home</a></li>
            <li><a href="#" class="active"><i class="fas fa-chart-line"></i> Analytics</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-users"></i> Staff</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-cogs"></i> Settings</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="stats-container">
            <div class="stats-header">
                <div class="stats-icon">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <h2>View statistics</h2>
                <p class="stats-subtitle">Select the type of statistics you want to view</p>
            </div>

            <div class="stats-options">
                <a href="<%= request.getContextPath() %>/staff/ServicePartStatsView.jsp" class="stats-option option-active">
                    <div class="option-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="option-content">
                        <div class="option-title">
                            Services/Parts Statistics
                            <span class="option-badge">Available</span>
                        </div>
                        <div class="option-desc">View revenue analytics for services and parts with detailed breakdowns and trends</div>
                    </div>
                    <i class="fas fa-chevron-right"></i>
                </a>

                <a href="#" class="stats-option option-inactive" onclick="showUnderConstruction(event)">
                    <div class="option-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="option-content">
                        <div class="option-title">
                            Customer Statistics
                            <span class="option-badge">Coming Soon</span>
                        </div>
                        <div class="option-desc">Analyze customer behavior, retention rates, and demographic insights</div>
                    </div>
                    <i class="fas fa-chevron-right"></i>
                </a>

                <a href="#" class="stats-option option-inactive" onclick="showUnderConstruction(event)">
                    <div class="option-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="option-content">
                        <div class="option-title">
                            Supplier Statistics
                            <span class="option-badge">Coming Soon</span>
                        </div>
                        <div class="option-desc">Monitor supplier performance, delivery times, and part quality metrics</div>
                    </div>
                    <i class="fas fa-chevron-right"></i>
                </a>
            </div>

            <div class="btn-container">
                <button class="back-btn" onclick="window.location.href='<%= request.getContextPath() %>/staff/ManagerHomepage.jsp'">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - GaraMan</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        body {
            height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow-x: hidden;
            background: linear-gradient(135deg, #1a2a3a 0%, #2c3e50 100%);
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

        /* Main content */
        .main-container {
            display: flex;
            width: 100%;
            height: 100vh;
            padding-top: 70px;
        }

        /* Left side - Branding */
        .branding-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 0 0 0 100px;
            color: white;
        }

        .branding-section h2 {
            font-size: 42px;
            margin-bottom: 20px;
            background: linear-gradient(to right, #3498db, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .branding-section p {
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 30px;
            color: #bdc3c7;
            max-width: 90%;
        }

        .features {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 30px;
        }

        .feature {
            display: flex;
            align-items: center;
            gap: 10px;
            width: 45%;
        }

        .feature i {
            color: #3498db;
            font-size: 20px;
        }

        /* Login container */
        .login-section {
            flex: 0 0 450px;
            display: flex;
            justify-content: flex-start; /* 🔹 Đẩy form login sang trái, sát branding */
            align-items: center;
            padding: 20px;
            margin-right: 200px; /* 🔹 Tạo khoảng cách 30px với mép phải */
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 35px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            width: 100%;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .login-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        .login-header {
            margin-bottom: 30px;
        }

        .login-icon {
            font-size: 40px;
            color: #3498db;
            margin-bottom: 15px;
        }

        h2 {
            margin-bottom: 10px;
            color: #2c3e50;
            font-size: 28px;
        }

        .login-subtitle {
            color: #7f8c8d;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            text-align: left;
            color: #2c3e50;
            font-weight: 500;
        }

        .input-group {
            position: relative;
            margin-bottom: 20px;
        }

        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px 12px 12px 45px;
            border-radius: 8px;
            border: 1px solid #bdc3c7;
            outline: none;
            font-size: 15px;
            transition: all 0.3s;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .remember {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .forgot-password {
            color: #3498db;
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        button {
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: #fff;
            border: none;
            padding: 14px 0;
            width: 100%;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
        }

        .register-link {
            margin-top: 25px;
            color: #7f8c8d;
            font-size: 14px;
        }

        .register-link a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .error {
            color: #e74c3c;
            background: #ffeaea;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: left;
            border-left: 4px solid #e74c3c;
        }

        /* Footer */
        .footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            background: rgba(10, 25, 47, 0.9);
            color: #bdc3c7;
            text-align: center;
            padding: 15px;
            font-size: 14px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .main-container {
                flex-direction: column;
                height: auto;
            }
            
            .branding-section {
                padding: 40px 30px;
                text-align: center;
            }
            
            .features {
                justify-content: center;
            }
            
            .login-section {
                flex: 1;
                padding: 20px 30px 60px;
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
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-tools"></i> Services</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-calendar-check"></i> Book Appointment</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-phone"></i> Contact</a></li>
            <li><a href="#" onclick="showUnderConstruction(event)"><i class="fas fa-info-circle"></i> About</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Branding Section -->
        <div class="branding-section">
            <h2>Premium Car Care & Maintenance</h2>
            <p>GaraMan offers comprehensive automotive services with state-of-the-art technology and expert technicians.<br>From routine maintenance to complex repairs, we keep your vehicle running smoothly.</p>
            
            <div class="features">
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>Expert Technicians</span>
                </div>
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>Quality Parts</span>
                </div>
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>Fast Service</span>
                </div>
                <div class="feature">
                    <i class="fas fa-check-circle"></i>
                    <span>Affordable Pricing</span>
                </div>
            </div>
        </div>
        
        <!-- Login Section -->
        <div class="login-section">
            <div class="login-container">
                <div class="login-header">
                    <div class="login-icon">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <h2>Login to GaraMan</h2>
                    <p class="login-subtitle">Access your account to manage services and appointments</p>
                </div>

                <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
                <% if (errorMessage != null) { %>
                    <div class="error"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></div>
                <% } %>

                <form action="SystemUserController" method="POST">
                    <label for="username">Username</label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" id="username" name="username" required placeholder="Enter your username" value="vana">
                    </div>

                    <label for="password">Password</label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" required placeholder="Enter your password" value="pass123">
                    </div>

                    <div class="remember-forgot">
                        <div class="remember">
                            <input type="checkbox" id="remember">
                            <label for="remember">Remember me</label>
                        </div>
                        <a href="#" class="forgot-password" onclick="showUnderConstruction(event)">Forgot Password?</a>
                    </div>

                    <button type="submit">Login</button>
                </form>
                
                <div class="register-link">
                    Don't have an account? <a href="#" onclick="showUnderConstruction(event)">Register here</a>
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
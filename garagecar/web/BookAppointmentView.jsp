<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - GaraMan</title>
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

        .appointment-container {
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

        .appointment-container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #3498db, #2ecc71);
        }

        .appointment-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .appointment-icon {
            font-size: 50px;
            color: #3498db;
            margin-bottom: 15px;
        }

        h2 {
            margin-bottom: 10px;
            color: #2c3e50;
            font-size: 32px;
        }

        .appointment-subtitle {
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

        input[type="date"], select, textarea {
            display: block;
            width: 100%;
            padding: 12px 12px 12px 45px;
            border: 1px solid #bdc3c7;
            border-radius: 8px;
            font-size: 15px;
            outline: none;
            transition: all 0.3s;
            background: white;
            box-sizing: border-box;
        }

        input[type="date"]:focus, select:focus, textarea:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }

        textarea {
            resize: none;
            height: 100px;
            padding-left: 15px;
        }

        .btn-container {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-top: 30px;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.8s ease 0.6s forwards;
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

        .back-btn {
            background: #95a5a6;
            color: white;
        }

        .back-btn:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }

        .next-btn {
            background: linear-gradient(to right, #3498db, #2ecc71);
            color: white;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .next-btn:hover {
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
            
            .appointment-container {
                padding: 30px 25px;
            }
            
            .btn-container {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .appointment-container {
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

        // Timeslot functionality
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById("date");
            const timeslotSelect = document.getElementById("timeslot");

            // Danh sách timeslot cố định trong ngày
            const allTimeslots = [
                "08:00 - 09:00",
                "09:00 - 10:00",
                "10:00 - 11:00",
                "11:00 - 12:00",
                "13:00 - 14:00",
                "14:00 - 15:00",
                "15:00 - 16:00",
                "16:00 - 17:00",
                "17:00 - 18:00",
                "18:00 - 19:00",
                "19:00 - 20:00"
            ];

            const today = new Date().toISOString().split("T")[0];
            dateInput.min = today;

            dateInput.addEventListener("change", () => {
                const selectedDate = dateInput.value;
                timeslotSelect.innerHTML = "";

                if (!selectedDate) {
                    timeslotSelect.innerHTML = "<option value=''>-- Please choose a date first --</option>";
                    return;
                }

                // Lấy giờ hiện tại (nếu ngày chọn là hôm nay)
                const now = new Date();
                const currentHour = now.getHours();
                const currentMinute = now.getMinutes();

                // Nếu người dùng chọn hôm nay => chỉ hiện slot sau giờ hiện tại
                let availableSlots = allTimeslots;
                const isToday = selectedDate === today;
                if (isToday) {
                    availableSlots = allTimeslots.filter(slot => {
                        const startHour = parseInt(slot.split(":")[0]);
                        // Nếu là giờ hiện tại nhưng phút > 30 => bỏ luôn slot đó
                        return startHour > currentHour || (startHour === currentHour && currentMinute < 30);
                    });
                }

                if (availableSlots.length === 0) {
                    timeslotSelect.innerHTML = "<option>No available timeslots for today</option>";
                } else {
                    for (const slot of availableSlots) {
                        const option = document.createElement("option");
                        option.value = slot;
                        option.textContent = slot;
                        timeslotSelect.appendChild(option);
                    }
                }
            });

            timeslotSelect.addEventListener("focus", () => {
                if (!dateInput.value) {
                    alert("Please select a date first.");
                    dateInput.focus();
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
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-calendar-check"></i> Book Appointment</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-history"></i> History</a></li>
            <li><a href="#" onclick="alert('🚧 This function is under construction 🚧')"><i class="fas fa-phone"></i> Contact</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="appointment-container">
            <div class="appointment-header">
                <div class="appointment-icon">
                    <i class="fas fa-calendar-plus"></i>
                </div>
                <h2>Book Appointment</h2>
                <p class="appointment-subtitle">Schedule your vehicle service with us</p>
            </div>

            <form action="ConfirmView.jsp" method="POST">
                <div class="form-group">
                    <label for="date">Select Date</label>
                    <div class="input-with-icon">
                        <i class="fas fa-calendar-alt"></i>
                        <input type="date" id="date" name="date" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="timeslot">Select Timeslot</label>
                    <div class="input-with-icon">
                        <i class="fas fa-clock"></i>
                        <select id="timeslot" name="timeslot" required>
                            <option value="">-- Please choose a date first --</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="note">Additional Notes</label>
                    <textarea id="note" name="note" placeholder="Enter any special requests or details about your vehicle..."></textarea>
                </div>

                <div class="btn-container">
                    <button type="button" class="btn back-btn" onclick="window.location.href='CustomerHomepage.jsp'">
                        <i class="fas fa-arrow-left"></i> Go Back
                    </button>
                    <button type="submit" class="btn next-btn">
                        Next <i class="fas fa-arrow-right"></i>
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
# 🍔 TapFood — Food Delivery Web Application

A full-stack food delivery web application built with **Core Java**, inspired by real-world food delivery platforms. TapFood lets users browse restaurants, search for dishes, place orders, and track them in real time — with a complete admin panel to manage the platform.

---

## 📖 About the Project

TapFood was built to apply backend engineering concepts in a real, end-to-end application — not just isolated exercises. It covers authentication, session management, cart logic, database transactions, and full CRUD operations, all built using **pure Java Servlets and JSP**, without relying on frameworks like Spring.

---

## 🛠️ Tech Stack

| Layer        | Technology                          |
|--------------|--------------------------------------|
| Backend      | Java, Servlets, JDBC                 |
| Frontend     | JSP, HTML5, CSS3, JavaScript         |
| Database     | MySQL                                |
| Server       | Apache Tomcat 10.1 (Jakarta EE)       |
| Architecture | MVC + DAO Design Pattern             |
| Security     | BCrypt Password Hashing              |

---

## ✅ Features

### User Side
- 🏠 Homepage with hero banner and restaurant listings
- 🔍 Smart search — search by restaurant name or dish name
- 🎯 Filters — Top Rated, Fast Delivery, Veg Only
- 🎨 Dynamic color theming per restaurant
- 🛒 Single-restaurant cart with conflict detection
- ⚡ AJAX-powered cart updates (no page reload)
- 🔐 Secure login & registration (BCrypt password hashing)
- 💳 Checkout with multiple payment options (COD / UPI / Card)
- 📦 Real-time order tracking
- 📋 Order history

### Admin Side
- 📊 Admin dashboard with live platform stats
- 🏪 Manage restaurants (Create, Read, Update, Delete)
- 🍽️ Manage menu items (Create, Read, Update, Delete)
- 📦 Manage orders and update order status
- 👥 Manage registered users

---

## 🏗️ Architecture

The project follows the **MVC (Model-View-Controller)** pattern combined with the **DAO (Data Access Object)** pattern:

- **Model** — Java classes representing entities (Restaurant, MenuItem, User, Order)
- **View** — JSP pages for rendering the UI
- **Controller** — Servlets handling requests and business logic
- **DAO Layer** — Separates database access logic from business logic, using JDBC

---

## ⚙️ Setup & Installation

### Prerequisites
- Java JDK 17+
- Apache Tomcat 10.1
- MySQL 8+
- Maven
- An IDE (Eclipse / IntelliJ)

### Steps

1. **Clone the repository**
```bash
   git clone https://github.com/Nikita-Patil-10/TapFood.git
```

2. **Set up the database**
   - Create a MySQL database (e.g., `tapfood_db`)
   - Import the provided SQL schema file (see `/database` folder if included)
   - Update your database credentials in the DB config file

3. **Configure the project**
   - Open the project in your IDE as a Maven project
   - Update `DBConnection` (or your config file) with your MySQL username and password

4. **Build & Deploy**
   - Right-click the project → Run As → Run on Server (Tomcat)
   - Or build a WAR file and deploy it to your Tomcat `webapps` folder

5. **Access the app**
6. http://localhost:8080/TapFood/home




## 🔗 Quick URL Reference

| Page         | URL                                       |
|--------------|--------------------------------------------|
| Home         | `localhost:8080/TapFood/home`                            |
| Login        | `localhost:8080/TapFood/login`                           |
| My Orders    | `localhost:8080/TapFood/orders`                          |
| Admin Panel  | `localhost:8080/TapFood/admin/dashboard`                 |

---


## 🚀 Future Improvements

- Payment gateway integration
- Real-time notifications
- Restaurant owner dashboard
- Ratings & reviews system

---

## 👩‍💻 Author

**Nikita Patil**
Feel free to connect or reach out with feedback!

---

## 📄 License

This project is open source and available for learning purposes.

<%--
    dashboard.jsp — Admin Dashboard
    Location: src/main/webapp/jsp/admin/dashboard.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon">🍔</div>
        <div>
            <div class="sidebar-logo-text">TapFood</div>
        </div>
        <span class="sidebar-logo-badge">ADMIN</span>
    </div>
    <nav class="sidebar-nav">
        <div class="sidebar-section-label">Main</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${activePage eq 'dashboard' ? 'active' : ''}">
            <span class="sidebar-link-icon">📊</span> Dashboard
        </a>
        <div class="sidebar-section-label">Manage</div>
        <a href="${pageContext.request.contextPath}/admin/restaurants" class="sidebar-link ${activePage eq 'restaurants' ? 'active' : ''}">
            <span class="sidebar-link-icon">🏪</span> Restaurants
        </a>
        <a href="${pageContext.request.contextPath}/admin/menu" class="sidebar-link ${activePage eq 'menu' ? 'active' : ''}">
            <span class="sidebar-link-icon">🍽️</span> Menu Items
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link ${activePage eq 'orders' ? 'active' : ''}">
            <span class="sidebar-link-icon">📦</span> Orders
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link ${activePage eq 'users' ? 'active' : ''}">
            <span class="sidebar-link-icon">👥</span> Users
        </a>
        <div class="sidebar-section-label">Site</div>
        <a href="${pageContext.request.contextPath}/home" class="sidebar-link">
            <span class="sidebar-link-icon">🌐</span> View Site
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="sidebar-avatar">${sessionScope.loggedInUser.firstName.substring(0,1).toUpperCase()}</div>
            <div>
                <div class="sidebar-user-name">${sessionScope.loggedInUser.firstName}</div>
                <div class="sidebar-user-role">Administrator</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout">
            🚪 Logout
        </a>
    </div>
</aside>

<!-- MAIN -->
<div class="main-content">
    <div class="topbar">
        <div>
            <div class="topbar-title">Dashboard</div>
            <div class="topbar-sub">Welcome back, ${sessionScope.loggedInUser.firstName}!</div>
        </div>
        <div class="topbar-actions">
            <a href="${pageContext.request.contextPath}/admin/restaurants?action=add" class="topbar-btn topbar-btn-primary">+ Add Restaurant</a>
            <a href="${pageContext.request.contextPath}/admin/menu?action=add" class="topbar-btn topbar-btn-outline">+ Add Menu Item</a>
        </div>
    </div>

    <div class="page-content">

        <!-- Flash Message -->
        <c:if test="${not empty sessionScope.adminMsg}">
            <div class="admin-alert ${sessionScope.adminMsg.startsWith('✅') ? 'success' : 'error'}">
                ${sessionScope.adminMsg}
            </div>
            <c:remove var="adminMsg" scope="session"/>
        </c:if>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon red">🏪</div>
                <div>
                    <div class="stat-value">${totalRestaurants}</div>
                    <div class="stat-label">Total Restaurants</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue">👥</div>
                <div>
                    <div class="stat-value">${totalUsers}</div>
                    <div class="stat-label">Total Customers</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">📦</div>
                <div>
                    <div class="stat-value">${totalOrders}</div>
                    <div class="stat-label">Total Orders</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">💰</div>
                <div>
                    <div class="stat-value">₹<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="0"/></div>
                    <div class="stat-label">Total Revenue</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple">📅</div>
                <div>
                    <div class="stat-value">${todayOrders}</div>
                    <div class="stat-label">Today's Orders</div>
                </div>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">📦 Recent Orders</div>
                <a href="${pageContext.request.contextPath}/admin/orders" class="topbar-btn topbar-btn-outline">View All →</a>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Restaurant</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${recentOrders}">
                        <tr>
                            <td><strong>#${order.orderId}</strong></td>
                            <td>${order.specialNotes}</td>
                            <td>${order.restaurantName}</td>
                            <td><strong>₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="0"/></strong></td>
                            <td>
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${order.status eq 'PENDING'}">badge-warning</c:when>
                                        <c:when test="${order.status eq 'PREPARING'}">badge-orange</c:when>
                                        <c:when test="${order.status eq 'OUT_FOR_DELIVERY'}">badge-info</c:when>
                                        <c:when test="${order.status eq 'DELIVERED'}">badge-success</c:when>
                                        <c:when test="${order.status eq 'CANCELLED'}">badge-danger</c:when>
                                        <c:otherwise>badge-gray</c:otherwise>
                                    </c:choose>">
                                    ${order.statusIcon} ${order.statusDisplay}
                                </span>
                            </td>
                            <td style="color:var(--text-light);font-size:12px;">${order.formattedOrderDate}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?id=${order.orderId}" class="action-btn btn-view">View</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentOrders}">
                        <tr><td colspan="7" style="text-align:center;padding:32px;color:var(--text-light);">No orders yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

    </div>
</div>
</body>
</html>

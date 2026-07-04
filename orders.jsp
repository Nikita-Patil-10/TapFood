<%--
    orders.jsp — Admin Orders List
    Location: src/main/webapp/jsp/admin/orders.jsp
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

<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="sidebar-logo-icon">🍔</div>
        <div><div class="sidebar-logo-text">TapFood</div></div>
        <span class="sidebar-logo-badge">ADMIN</span>
    </div>
    <nav class="sidebar-nav">
        <div class="sidebar-section-label">Main</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link"><span class="sidebar-link-icon">📊</span> Dashboard</a>
        <div class="sidebar-section-label">Manage</div>
        <a href="${pageContext.request.contextPath}/admin/restaurants" class="sidebar-link"><span class="sidebar-link-icon">🏪</span> Restaurants</a>
        <a href="${pageContext.request.contextPath}/admin/menu" class="sidebar-link"><span class="sidebar-link-icon">🍽️</span> Menu Items</a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link active"><span class="sidebar-link-icon">📦</span> Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link"><span class="sidebar-link-icon">👥</span> Users</a>
        <div class="sidebar-section-label">Site</div>
        <a href="${pageContext.request.contextPath}/home" class="sidebar-link"><span class="sidebar-link-icon">🌐</span> View Site</a>
    </nav>
    <div class="sidebar-footer">
        <div class="sidebar-user">
            <div class="sidebar-avatar">${sessionScope.loggedInUser.firstName.substring(0,1).toUpperCase()}</div>
            <div>
                <div class="sidebar-user-name">${sessionScope.loggedInUser.firstName}</div>
                <div class="sidebar-user-role">Administrator</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout">🚪 Logout</a>
    </div>
</aside>

<div class="main-content">
    <div class="topbar">
        <div>
            <div class="topbar-title">📦 Orders</div>
            <div class="topbar-sub">${orders.size()} orders</div>
        </div>
    </div>

    <div class="page-content">

        <c:if test="${not empty sessionScope.adminMsg}">
            <div class="admin-alert success">${sessionScope.adminMsg}</div>
            <c:remove var="adminMsg" scope="session"/>
        </c:if>

        <!-- Status Filter Tabs -->
        <div class="filter-bar">
            <a href="${pageContext.request.contextPath}/admin/orders"
               class="filter-tab ${activeStatus eq 'ALL' ? 'active' : ''}">All</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=PENDING"
               class="filter-tab ${activeStatus eq 'PENDING' ? 'active' : ''}">🕐 Pending</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=PREPARING"
               class="filter-tab ${activeStatus eq 'PREPARING' ? 'active' : ''}">👨‍🍳 Preparing</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=OUT_FOR_DELIVERY"
               class="filter-tab ${activeStatus eq 'OUT_FOR_DELIVERY' ? 'active' : ''}">🚴 Out for Delivery</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=DELIVERED"
               class="filter-tab ${activeStatus eq 'DELIVERED' ? 'active' : ''}">✅ Delivered</a>
            <a href="${pageContext.request.contextPath}/admin/orders?status=CANCELLED"
               class="filter-tab ${activeStatus eq 'CANCELLED' ? 'active' : ''}">❌ Cancelled</a>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">
                    ${activeStatus eq 'ALL' ? 'All Orders' : activeStatus} Orders
                </div>
                <div class="search-box">
                    <span class="search-box-icon">🔍</span>
                    <input type="text" id="searchInput" placeholder="Search orders..." oninput="filterTable()">
                </div>
            </div>
            <table class="admin-table" id="orderTable">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Restaurant</th>
                        <th>Amount</th>
                        <th>Payment</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Update Status</th>
                        <th>Detail</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td><strong>#${order.orderId}</strong></td>
                            <td style="font-size:13px;">${order.specialNotes}</td>
                            <td style="font-size:13px;">${order.restaurantName}</td>
                            <td><strong>₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="0"/></strong></td>
                            <td>
                                <span class="badge badge-gray" style="font-size:11px;">
                                    <c:choose>
                                        <c:when test="${order.paymentMode eq 'CASH_ON_DELIVERY'}">💵 COD</c:when>
                                        <c:when test="${order.paymentMode eq 'UPI'}">📱 UPI</c:when>
                                        <c:otherwise>💳 Card</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
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
                            <td style="color:var(--text-light);font-size:12px;white-space:nowrap;">${order.formattedOrderDate}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/admin/orders"
                                      style="display:flex;gap:6px;align-items:center;">
                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                    <select name="status" class="form-select" style="padding:5px 8px;font-size:12px;min-width:140px;">
                                        <option value="PENDING"          ${order.status eq 'PENDING'          ? 'selected':''}>🕐 Pending</option>
                                        <option value="PREPARING"        ${order.status eq 'PREPARING'        ? 'selected':''}>👨‍🍳 Preparing</option>
                                        <option value="OUT_FOR_DELIVERY" ${order.status eq 'OUT_FOR_DELIVERY' ? 'selected':''}>🚴 Out for Delivery</option>
                                        <option value="DELIVERED"        ${order.status eq 'DELIVERED'        ? 'selected':''}>✅ Delivered</option>
                                        <option value="CANCELLED"        ${order.status eq 'CANCELLED'        ? 'selected':''}>❌ Cancelled</option>
                                    </select>
                                    <button type="submit" class="action-btn btn-success">Update</button>
                                </form>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders?id=${order.orderId}"
                                   class="action-btn btn-view">👁 View</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr><td colspan="9" style="text-align:center;padding:40px;color:var(--text-light);">No orders found for this filter.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function filterTable() {
    var val  = document.getElementById('searchInput').value.toLowerCase();
    var rows = document.querySelectorAll('#orderTable tbody tr');
    rows.forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(val) ? '' : 'none';
    });
}
</script>
</body>
</html>

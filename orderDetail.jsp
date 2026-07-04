<%--
    orderDetail.jsp — Admin Order Detail
    Location: src/main/webapp/jsp/admin/orderDetail.jsp
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
            <div class="topbar-title">Order #${order.orderId}</div>
            <div class="topbar-sub">
                <a href="${pageContext.request.contextPath}/admin/orders" style="color:var(--text-light);">Orders</a>
                › #${order.orderId}
            </div>
        </div>
        <div class="topbar-actions">
            <a href="${pageContext.request.contextPath}/admin/orders" class="topbar-btn topbar-btn-outline">← Back to Orders</a>
        </div>
    </div>

    <div class="page-content">
        <c:choose>
            <c:when test="${empty order}">
                <div class="admin-alert error">Order not found.</div>
            </c:when>
            <c:otherwise>

        <div style="display:grid;grid-template-columns:1fr 340px;gap:20px;align-items:start;">

            <!-- LEFT -->
            <div>
                <!-- Order Items -->
                <div class="table-card" style="margin-bottom:20px;">
                    <div class="table-card-header">
                        <div class="table-card-title">🍽️ Items Ordered (${order.restaurantName})</div>
                    </div>
                    <table class="admin-table">
                        <thead>
                            <tr><th>Item</th><th>Qty</th><th>Unit Price</th><th>Total</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.orderItems}">
                                <tr>
                                    <td>
                                        <div style="display:flex;align-items:center;gap:8px;">
                                            <div style="width:32px;height:32px;border-radius:6px;overflow:hidden;background:#f0f0f5;flex-shrink:0;">
                                                <img src="${pageContext.request.contextPath}/images/${item.image}"
                                                     style="width:100%;height:100%;object-fit:cover;"
                                                     onerror="this.style.display='none'">
                                            </div>
                                            <span style="font-weight:600;">${item.name}</span>
                                            <span class="badge ${item.veg ? 'badge-success' : 'badge-danger'}" style="font-size:10px;">${item.veg ? 'Veg' : 'Non-Veg'}</span>
                                        </div>
                                    </td>
                                    <td>× ${item.quantity}</td>
                                    <td>₹<fmt:formatNumber value="${item.price}" maxFractionDigits="0"/></td>
                                    <td><strong>₹<fmt:formatNumber value="${item.lineTotal}" maxFractionDigits="0"/></strong></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty order.orderItems}">
                                <tr><td colspan="4" style="text-align:center;color:var(--text-light);padding:20px;">No items found.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Delivery Address -->
                <div class="table-card">
                    <div class="table-card-header"><div class="table-card-title">📍 Delivery Details</div></div>
                    <div style="padding:20px;display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                        <div>
                            <div style="font-size:11px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">Address</div>
                            <div style="font-size:13.5px;color:var(--text-dark);line-height:1.6;">${order.deliveryAddress}</div>
                        </div>
                        <div>
                            <div style="font-size:11px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">Payment</div>
                            <div style="font-size:13.5px;font-weight:600;">
                                <c:choose>
                                    <c:when test="${order.paymentMode eq 'CASH_ON_DELIVERY'}">💵 Cash on Delivery</c:when>
                                    <c:when test="${order.paymentMode eq 'UPI'}">📱 UPI</c:when>
                                    <c:otherwise>💳 Card / Net Banking</c:otherwise>
                                </c:choose>
                            </div>
                            <div style="font-size:12px;color:var(--text-light);margin-top:4px;">Status: ${order.paymentStatus}</div>
                        </div>
                        <c:if test="${not empty order.specialNotes}">
                            <div style="grid-column:1/-1;">
                                <div style="font-size:11px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">Special Notes</div>
                                <div style="font-size:13.5px;color:var(--text-mid);">${order.specialNotes}</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- RIGHT: Summary + Status Update -->
            <div>
                <!-- Price Summary -->
                <div class="table-card" style="margin-bottom:16px;">
                    <div class="table-card-header"><div class="table-card-title">💰 Price Breakdown</div></div>
                    <div style="padding:16px 20px;">
                        <div style="display:flex;justify-content:space-between;padding:6px 0;font-size:13.5px;color:var(--text-mid);">
                            <span>Subtotal</span>
                            <span>₹<fmt:formatNumber value="${order.totalAmount - order.deliveryFee - order.taxAmount}" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex;justify-content:space-between;padding:6px 0;font-size:13.5px;color:var(--text-mid);">
                            <span>Delivery Fee</span>
                            <span>₹<fmt:formatNumber value="${order.deliveryFee}" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex;justify-content:space-between;padding:6px 0;font-size:13.5px;color:var(--text-mid);">
                            <span>GST</span>
                            <span>₹<fmt:formatNumber value="${order.taxAmount}" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex;justify-content:space-between;padding:12px 0 6px;font-size:17px;font-weight:800;color:var(--text-dark);border-top:2px solid var(--border);margin-top:6px;">
                            <span>Total</span>
                            <span style="color:var(--primary);">₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="0"/></span>
                        </div>
                    </div>
                </div>

                <!-- Current Status -->
                <div class="table-card" style="margin-bottom:16px;">
                    <div class="table-card-header"><div class="table-card-title">📋 Current Status</div></div>
                    <div style="padding:16px 20px;">
                        <div style="text-align:center;margin-bottom:16px;">
                            <span class="badge
                                <c:choose>
                                    <c:when test="${order.status eq 'PENDING'}">badge-warning</c:when>
                                    <c:when test="${order.status eq 'PREPARING'}">badge-orange</c:when>
                                    <c:when test="${order.status eq 'OUT_FOR_DELIVERY'}">badge-info</c:when>
                                    <c:when test="${order.status eq 'DELIVERED'}">badge-success</c:when>
                                    <c:when test="${order.status eq 'CANCELLED'}">badge-danger</c:when>
                                    <c:otherwise>badge-gray</c:otherwise>
                                </c:choose>"
                                style="font-size:14px;padding:8px 20px;">
                                ${order.statusIcon} ${order.statusDisplay}
                            </span>
                        </div>
                        <div style="font-size:12px;color:var(--text-light);text-align:center;">
                            Order placed: ${order.formattedOrderDate}
                        </div>
                    </div>
                </div>

                <!-- Update Status Form -->
                <div class="table-card">
                    <div class="table-card-header"><div class="table-card-title">🔄 Update Status</div></div>
                    <div style="padding:16px 20px;">
                        <form method="post" action="${pageContext.request.contextPath}/admin/orders">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <div class="form-group" style="margin-bottom:12px;">
                                <label class="form-label">New Status</label>
                                <select name="status" class="form-select">
                                    <option value="PENDING"          ${order.status eq 'PENDING'          ? 'selected':''}>🕐 Pending</option>
                                    <option value="PREPARING"        ${order.status eq 'PREPARING'        ? 'selected':''}>👨‍🍳 Preparing</option>
                                    <option value="OUT_FOR_DELIVERY" ${order.status eq 'OUT_FOR_DELIVERY' ? 'selected':''}>🚴 Out for Delivery</option>
                                    <option value="DELIVERED"        ${order.status eq 'DELIVERED'        ? 'selected':''}>✅ Delivered</option>
                                    <option value="CANCELLED"        ${order.status eq 'CANCELLED'        ? 'selected':''}>❌ Cancelled</option>
                                </select>
                            </div>
                            <button type="submit" class="btn-submit" style="width:100%;">Update Status →</button>
                        </form>
                    </div>
                </div>
            </div>

        </div>

            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>

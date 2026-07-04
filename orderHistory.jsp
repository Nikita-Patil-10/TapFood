<%--
    orderHistory.jsp — My Orders Page
    Location: src/main/webapp/jsp/orderHistory.jsp
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .orders-page {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 24px 80px;
        }
        .orders-header {
            margin-bottom: 28px;
        }
        .orders-header h1 {
            font-size: 28px; font-weight: 900;
            letter-spacing: -0.5px; color: var(--text-dark);
            margin-bottom: 4px;
        }
        .orders-header p { font-size: 14px; color: var(--text-light); }

        /* Order Card */
        .order-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 20px;
            transition: box-shadow 0.2s;
        }
        .order-card:hover { box-shadow: var(--shadow-md); }

        .order-card-header {
            padding: 16px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            border-bottom: 1px solid var(--border);
            flex-wrap: wrap;
        }
        .order-rest-info {
            display: flex; align-items: center; gap: 12px;
        }
        .order-rest-img {
            width: 44px; height: 44px;
            border-radius: 10px; object-fit: cover;
            background: var(--border); flex-shrink: 0;
        }
        .order-rest-name {
            font-size: 15px; font-weight: 800; color: var(--text-dark);
        }
        .order-date {
            font-size: 12px; color: var(--text-light); margin-top: 2px;
        }

        /* Status badge */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 12px; font-weight: 700;
            white-space: nowrap;
        }
        .status-badge.pending          { background: #fef9c3; color: #854d0e; }
        .status-badge.preparing        { background: #fff7ed; color: #c2410c; }
        .status-badge.out-for-delivery { background: #eff6ff; color: #1d4ed8; }
        .status-badge.delivered        { background: #f0fdf4; color: #15803d; }
        .status-badge.cancelled        { background: #fef2f2; color: #dc2626; }

        .order-card-body { padding: 16px 20px; }

        /* Items preview */
        .order-items-preview {
            display: flex; gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }
        .item-preview-chip {
            display: flex; align-items: center; gap: 6px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 5px 10px;
            font-size: 12.5px; color: var(--text-mid);
            font-weight: 500;
        }

        .order-card-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 20px;
            background: var(--bg);
            border-top: 1px solid var(--border);
            flex-wrap: wrap;
            gap: 12px;
        }
        .order-total {
            font-size: 16px; font-weight: 800; color: var(--text-dark);
        }
        .order-total span { color: var(--primary); }

        .reorder-btn {
            display: flex; align-items: center; gap: 7px;
            padding: 9px 20px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff;
            border-radius: 50px;
            font-size: 13px; font-weight: 700;
            transition: all 0.2s;
            text-decoration: none;
            border: none; cursor: pointer;
        }
        .reorder-btn:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(200,2,56,0.3); }

        .view-btn {
            display: flex; align-items: center; gap: 7px;
            padding: 9px 20px;
            border: 1.5px solid var(--border);
            color: var(--text-mid);
            border-radius: 50px;
            font-size: 13px; font-weight: 600;
            transition: all 0.2s;
            text-decoration: none;
        }
        .view-btn:hover { border-color: var(--primary); color: var(--primary); }

        /* Empty state */
        .empty-orders {
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
        }
        .empty-orders-icon { font-size: 72px; margin-bottom: 20px; display: block; }
        .empty-orders h3   { font-size: 22px; font-weight: 800; margin-bottom: 8px; }
        .empty-orders p    { color: var(--text-light); margin-bottom: 28px; font-size: 15px; }

        /* Stats bar */
        .orders-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            text-align: center;
        }
        .stat-card-value { font-size: 24px; font-weight: 900; color: var(--primary); }
        .stat-card-label { font-size: 12px; color: var(--text-light); margin-top: 4px; }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar" id="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">
            <div class="nav-logo-icon">🍔</div>
            <span class="nav-logo-text">TapFood</span>
        </a>
        <div class="nav-actions" style="margin-left:auto;">
            <a href="${pageContext.request.contextPath}/cart" class="nav-cart-btn">
                🛒 Cart
                <c:if test="${not empty sessionScope.cartCount and sessionScope.cartCount > 0}">
                    <span class="cart-badge">${sessionScope.cartCount}</span>
                </c:if>
            </a>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <div class="nav-user-pill">
                    <div class="nav-avatar">${sessionScope.loggedInUser.firstName.substring(0,1).toUpperCase()}</div>
                    Hi, ${sessionScope.loggedInUser.firstName}
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="nav-btn nav-btn-outline">Logout</a>
            </c:if>
        </div>
    </div>
</nav>

<div class="orders-page">

    <!-- Header -->
    <div class="orders-header">
        <h1>📋 My Orders</h1>
        <p>
            <a href="${pageContext.request.contextPath}/home" style="color:var(--text-light);">Home</a>
            › My Orders
        </p>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <!-- Empty -->
            <div class="empty-orders">
                <span class="empty-orders-icon">🍽️</span>
                <h3>No orders yet</h3>
                <p>You haven't placed any orders yet.<br>Explore restaurants and order something delicious!</p>
                <a href="${pageContext.request.contextPath}/home" class="btn-primary">
                    Browse Restaurants →
                </a>
            </div>
        </c:when>

        <c:otherwise>

            <!-- Stats Bar -->
            <div class="orders-stats">
                <div class="stat-card">
                    <div class="stat-card-value">${orders.size()}</div>
                    <div class="stat-card-label">Total Orders</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-value">
                        <c:set var="deliveredCount" value="0"/>
                        <c:forEach var="o" items="${orders}">
                            <c:if test="${o.status eq 'DELIVERED'}">
                                <c:set var="deliveredCount" value="${deliveredCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${deliveredCount}
                    </div>
                    <div class="stat-card-label">Delivered</div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-value">
                        <c:set var="totalSpend" value="0"/>
                        <c:forEach var="o" items="${orders}">
                            <c:set var="totalSpend" value="${totalSpend + o.totalAmount}"/>
                        </c:forEach>
                        ₹<fmt:formatNumber value="${totalSpend}" maxFractionDigits="0"/>
                    </div>
                    <div class="stat-card-label">Total Spent</div>
                </div>
            </div>

            <!-- Order Cards -->
            <c:forEach var="order" items="${orders}">
                <div class="order-card">

                    <!-- Header -->
                    <div class="order-card-header">
                        <div class="order-rest-info">
                            <img class="order-rest-img"
                                 src="${pageContext.request.contextPath}/images/${order.restaurantImage}"
                                 alt="${order.restaurantName}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-restaurant.jpg'">
                            <div>
                                <div class="order-rest-name">${order.restaurantName}</div>
                                <div class="order-date">
                                    Order #${order.orderId} · ${order.formattedOrderDate}
                                </div>
                            </div>
                        </div>
                        <div class="status-badge ${order.statusCssClass}">
                            ${order.statusIcon} ${order.statusDisplay}
                        </div>
                    </div>

                    <!-- Body: Items preview -->
                    <div class="order-card-body">
                        <div class="order-items-preview">
                            <c:forEach var="item" items="${order.orderItems}" begin="0" end="2">
                                <div class="item-preview-chip">
                                    ${item.name}
                                    <span style="color:var(--text-light);">×${item.quantity}</span>
                                </div>
                            </c:forEach>
                            <c:if test="${order.orderItems.size() > 3}">
                                <div class="item-preview-chip" style="color:var(--primary);border-color:var(--primary);">
                                    +${order.orderItems.size() - 3} more
                                </div>
                            </c:if>
                        </div>
                        <div style="font-size:13px;color:var(--text-light);">
                            <c:choose>
                                <c:when test="${order.paymentMode eq 'CASH_ON_DELIVERY'}">💵 Cash on Delivery</c:when>
                                <c:when test="${order.paymentMode eq 'UPI'}">📱 UPI</c:when>
                                <c:otherwise>💳 Card</c:otherwise>
                            </c:choose>
                            &nbsp;·&nbsp; 📍 ${order.deliveryAddress}
                        </div>
                    </div>

                    <!-- Footer -->
                    <div class="order-card-footer">
                        <div class="order-total">
                            Total: <span>₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="0"/></span>
                        </div>
                        <div style="display:flex;gap:10px;">
                            <a href="${pageContext.request.contextPath}/order?id=${order.orderId}"
                               class="view-btn">
                                View Details
                            </a>
                            <a href="${pageContext.request.contextPath}/restaurant?id=${order.restaurantId}"
                               class="reorder-btn">
                                🔄 Reorder
                            </a>
                        </div>
                    </div>

                </div>
            </c:forEach>

        </c:otherwise>
    </c:choose>

</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

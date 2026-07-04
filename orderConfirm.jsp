<%--
    orderConfirm.jsp — Order Confirmation + Tracking Timeline
    Location: src/main/webapp/jsp/orderConfirm.jsp
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
        .confirm-page {
            max-width: 720px;
            margin: 40px auto;
            padding: 0 24px 80px;
        }

        /* Success header */
        .confirm-hero {
            background: linear-gradient(135deg, #16a34a, #22c55e);
            border-radius: var(--radius-xl);
            padding: 40px;
            text-align: center;
            color: #fff;
            margin-bottom: 28px;
            position: relative;
            overflow: hidden;
        }
        .confirm-hero::before {
            content: '';
            position: absolute; inset: 0;
            background: url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Ccircle cx='20' cy='20' r='15'/%3E%3C/g%3E%3C/svg%3E");
        }
        .confirm-check {
            width: 72px; height: 72px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 36px;
            margin: 0 auto 16px;
            position: relative; z-index: 1;
            animation: popIn 0.5s cubic-bezier(0.175,0.885,0.32,1.275);
        }
        @keyframes popIn {
            0%   { transform: scale(0); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
        .confirm-title {
            font-size: 28px; font-weight: 900;
            margin-bottom: 8px; position: relative; z-index: 1;
        }
        .confirm-subtitle {
            font-size: 15px; opacity: 0.85;
            position: relative; z-index: 1;
        }
        .confirm-order-id {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 50px;
            padding: 6px 18px;
            font-size: 13px; font-weight: 700;
            margin-top: 14px;
            position: relative; z-index: 1;
        }

        /* Card */
        .confirm-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 20px;
        }
        .confirm-card-header {
            padding: 16px 24px;
            border-bottom: 1px solid var(--border);
            font-size: 15px; font-weight: 800;
            color: var(--text-dark);
            display: flex; align-items: center; gap: 8px;
        }
        .confirm-card-body { padding: 20px 24px; }

        /* Tracking Timeline */
        .tracking-timeline {
            display: flex;
            flex-direction: column;
            gap: 0;
        }
        .track-step {
            display: flex;
            gap: 16px;
            position: relative;
        }
        .track-step:not(:last-child) .track-icon::after {
            content: '';
            position: absolute;
            left: 17px;
            top: 38px;
            width: 2px;
            height: calc(100% - 10px);
            background: var(--border);
            z-index: 0;
        }
        .track-step.done:not(:last-child) .track-icon::after {
            background: #22c55e;
        }
        .track-icon {
            position: relative;
            flex-shrink: 0;
        }
        .track-dot {
            width: 36px; height: 36px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px;
            border: 2px solid var(--border);
            background: #fff;
            position: relative; z-index: 1;
        }
        .track-step.done   .track-dot { background: #22c55e; border-color: #22c55e; }
        .track-step.active .track-dot {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border-color: var(--primary);
            animation: pulse 1.5s ease-in-out infinite;
        }
        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(200,2,56,0.3); }
            50%       { box-shadow: 0 0 0 8px rgba(200,2,56,0); }
        }
        .track-content {
            padding: 6px 0 24px;
        }
        .track-label {
            font-size: 14px; font-weight: 700;
            color: var(--text-dark); margin-bottom: 2px;
        }
        .track-step.pending .track-label { color: var(--text-light); }
        .track-desc {
            font-size: 12.5px; color: var(--text-light);
        }
        .track-step.active .track-desc { color: var(--primary); font-weight: 500; }

        /* Order items */
        .order-item-row {
            display: flex; align-items: center;
            gap: 12px; padding: 10px 0;
            border-bottom: 1px solid var(--border);
            font-size: 14px;
        }
        .order-item-row:last-child { border-bottom: none; }
        .order-item-img {
            width: 48px; height: 40px;
            border-radius: 8px; object-fit: cover;
            background: var(--border); flex-shrink: 0;
        }
        .order-item-name { flex: 1; font-weight: 600; }
        .order-item-qty  { color: var(--text-light); }
        .order-item-price{ font-weight: 700; color: var(--primary); }

        /* Price breakdown */
        .price-row {
            display: flex; justify-content: space-between;
            font-size: 14px; color: var(--text-mid); padding: 6px 0;
        }
        .price-row.total {
            font-size: 17px; font-weight: 800; color: var(--text-dark);
            border-top: 2px solid var(--border);
            margin-top: 8px; padding-top: 14px;
        }
        .price-row.total span:last-child { color: var(--primary); }

        /* Address box */
        .address-box {
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 14px 18px;
            font-size: 13.5px;
            color: var(--text-mid);
            line-height: 1.6;
        }

        /* Action buttons */
        .confirm-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-top: 24px;
        }
        .btn-outline-primary {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            padding: 13px;
            border: 2px solid var(--primary);
            color: var(--primary);
            border-radius: 12px;
            font-size: 14px; font-weight: 700;
            transition: all 0.2s;
            text-decoration: none;
        }
        .btn-outline-primary:hover { background: var(--primary); color: #fff; }

        @media (max-width: 480px) {
            .confirm-actions { grid-template-columns: 1fr; }
            .confirm-hero    { padding: 28px 20px; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">
            <div class="nav-logo-icon">🍔</div>
            <span class="nav-logo-text">TapFood</span>
        </a>
        <div class="nav-actions" style="margin-left:auto;">
            <a href="${pageContext.request.contextPath}/orders" class="nav-btn nav-btn-outline">My Orders</a>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <div class="nav-user-pill">
                    <div class="nav-avatar">${sessionScope.loggedInUser.firstName.substring(0,1).toUpperCase()}</div>
                    Hi, ${sessionScope.loggedInUser.firstName}
                </div>
            </c:if>
        </div>
    </div>
</nav>

<div class="confirm-page">

    <!-- SUCCESS HERO -->
    <div class="confirm-hero">
        <div class="confirm-check">🎉</div>
        <div class="confirm-title">Order Placed Successfully!</div>
        <div class="confirm-subtitle">
            Your food is being prepared by ${order.restaurantName}.<br>
            Estimated delivery: <strong>${order.restaurantName ne null ? '30–40 mins' : '30 mins'}</strong>
        </div>
        <div class="confirm-order-id">Order #${order.orderId}</div>
    </div>

    <!-- TRACKING TIMELINE -->
    <div class="confirm-card">
        <div class="confirm-card-header">📍 Order Tracking</div>
        <div class="confirm-card-body">
            <div class="tracking-timeline">

                <div class="track-step done">
                    <div class="track-icon">
                        <div class="track-dot">✓</div>
                    </div>
                    <div class="track-content">
                        <div class="track-label">Order Placed</div>
                        <div class="track-desc">${order.formattedOrderDate}</div>
                    </div>
                </div>

                <div class="track-step ${order.status eq 'PREPARING' or order.status eq 'OUT_FOR_DELIVERY' or order.status eq 'DELIVERED' ? 'done' : order.status eq 'PENDING' ? 'active' : 'pending'}">
                    <div class="track-icon">
                        <div class="track-dot">
                            ${order.status eq 'PREPARING' or order.status eq 'OUT_FOR_DELIVERY' or order.status eq 'DELIVERED' ? '✓' : '👨‍🍳'}
                        </div>
                    </div>
                    <div class="track-content">
                        <div class="track-label">Preparing Your Order</div>
                        <div class="track-desc">Restaurant is cooking your food</div>
                    </div>
                </div>

                <div class="track-step ${order.status eq 'OUT_FOR_DELIVERY' or order.status eq 'DELIVERED' ? 'done' : order.status eq 'PREPARING' ? 'active' : 'pending'}">
                    <div class="track-icon">
                        <div class="track-dot">
                            ${order.status eq 'OUT_FOR_DELIVERY' or order.status eq 'DELIVERED' ? '✓' : '🚴'}
                        </div>
                    </div>
                    <div class="track-content">
                        <div class="track-label">Out for Delivery</div>
                        <div class="track-desc">Your rider is on the way</div>
                    </div>
                </div>

                <div class="track-step ${order.status eq 'DELIVERED' ? 'done' : order.status eq 'OUT_FOR_DELIVERY' ? 'active' : 'pending'}">
                    <div class="track-icon">
                        <div class="track-dot">
                            ${order.status eq 'DELIVERED' ? '✓' : '🏠'}
                        </div>
                    </div>
                    <div class="track-content" style="padding-bottom:0;">
                        <div class="track-label">Delivered</div>
                        <div class="track-desc">Enjoy your meal!</div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- ORDER ITEMS -->
    <div class="confirm-card">
        <div class="confirm-card-header">🍽️ Items Ordered</div>
        <div class="confirm-card-body">
            <c:forEach var="item" items="${order.orderItems}">
                <div class="order-item-row">
                    <img class="order-item-img"
                         src="${pageContext.request.contextPath}/images/${item.image}"
                         alt="${item.name}"
                         onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">
                    <span class="order-item-name">${item.name}</span>
                    <span class="order-item-qty">× ${item.quantity}</span>
                    <span class="order-item-price">${item.formattedLineTotal}</span>
                </div>
            </c:forEach>

            <div style="margin-top:16px;">
                <div class="price-row">
                    <span>Item Total</span>
                    <span>₹<fmt:formatNumber value="${order.totalAmount - order.deliveryFee - order.taxAmount}" maxFractionDigits="0"/></span>
                </div>
                <div class="price-row">
                    <span>Delivery Fee</span>
                    <span>₹<fmt:formatNumber value="${order.deliveryFee}" maxFractionDigits="0"/></span>
                </div>
                <div class="price-row">
                    <span>GST</span>
                    <span>₹<fmt:formatNumber value="${order.taxAmount}" maxFractionDigits="0"/></span>
                </div>
                <div class="price-row total">
                    <span>Total Paid</span>
                    <span>₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="0"/></span>
                </div>
            </div>
        </div>
    </div>

    <!-- DELIVERY ADDRESS -->
    <div class="confirm-card">
        <div class="confirm-card-header">📦 Delivery Details</div>
        <div class="confirm-card-body">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;flex-wrap:wrap;">
                <div>
                    <div style="font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:8px;">Delivery Address</div>
                    <div class="address-box">${order.deliveryAddress}</div>
                </div>
                <div>
                    <div style="font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:8px;">Payment</div>
                    <div class="address-box">
                        <div style="font-weight:700;color:var(--text-dark);">
                            <c:choose>
                                <c:when test="${order.paymentMode eq 'CASH_ON_DELIVERY'}">💵 Cash on Delivery</c:when>
                                <c:when test="${order.paymentMode eq 'UPI'}">📱 UPI</c:when>
                                <c:otherwise>💳 Card / Net Banking</c:otherwise>
                            </c:choose>
                        </div>
                        <div style="font-size:12px;margin-top:4px;color:var(--text-light);">Status: ${order.paymentStatus}</div>
                    </div>
                </div>
            </div>
            <c:if test="${not empty order.specialNotes}">
                <div style="margin-top:16px;">
                    <div style="font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:8px;">Special Instructions</div>
                    <div class="address-box">${order.specialNotes}</div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- ACTION BUTTONS -->
    <div class="confirm-actions">
        <a href="${pageContext.request.contextPath}/orders" class="btn-outline-primary">
            📋 View All Orders
        </a>
        <a href="${pageContext.request.contextPath}/home" class="btn-primary" style="justify-content:center;">
            🍽️ Order Again
        </a>
    </div>

</div><!-- /confirm-page -->

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

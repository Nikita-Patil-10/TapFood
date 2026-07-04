<%--
    checkout.jsp — TapFood Checkout Page
    Location: src/main/webapp/jsp/checkout.jsp
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
        .checkout-page {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 24px 80px;
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 32px;
            align-items: start;
        }

        /* Step indicator */
        .checkout-steps {
            display: flex;
            align-items: center;
            gap: 0;
            margin-bottom: 32px;
            max-width: 1100px;
            margin-left: auto;
            margin-right: auto;
            padding: 24px 24px 0;
        }
        .step {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 600;
        }
        .step-num {
            width: 28px; height: 28px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 800;
            flex-shrink: 0;
        }
        .step.done .step-num  { background: #22c55e; color: #fff; }
        .step.active .step-num { background: linear-gradient(135deg, var(--primary), var(--accent)); color: #fff; }
        .step.pending .step-num { background: var(--border); color: var(--text-light); }
        .step.done   { color: #22c55e; }
        .step.active { color: var(--primary); }
        .step.pending{ color: var(--text-light); }
        .step-line   { flex: 1; height: 2px; background: var(--border); margin: 0 12px; }
        .step-line.done { background: #22c55e; }

        /* Form card */
        .checkout-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .checkout-card-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .checkout-card-icon {
            width: 36px; height: 36px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
        }
        .checkout-card-title { font-size: 17px; font-weight: 800; color: var(--text-dark); }
        .checkout-card-body  { padding: 24px; }

        /* Form inputs */
        .form-group   { margin-bottom: 20px; }
        .form-label   {
            display: block;
            font-size: 13px; font-weight: 700;
            color: var(--text-dark); margin-bottom: 8px;
        }
        .form-input, .form-textarea {
            width: 100%;
            padding: 13px 16px;
            border: 1.5px solid var(--border);
            border-radius: 12px;
            font-size: 14px; font-family: inherit;
            color: var(--text-dark); background: #fff;
            transition: all 0.2s; outline: none;
            resize: none;
        }
        .form-input:focus, .form-textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(200,2,56,0.08);
        }
        .form-input::placeholder, .form-textarea::placeholder { color: var(--text-light); }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

        /* Payment options */
        .payment-options { display: flex; flex-direction: column; gap: 12px; }
        .payment-option {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 18px;
            border: 1.5px solid var(--border);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .payment-option:hover { border-color: var(--primary); background: rgba(200,2,56,0.02); }
        .payment-option.selected { border-color: var(--primary); background: rgba(200,2,56,0.04); }
        .payment-option input[type="radio"] { accent-color: var(--primary); width: 16px; height: 16px; }
        .payment-option-icon  { font-size: 22px; }
        .payment-option-label { font-size: 14px; font-weight: 600; color: var(--text-dark); }
        .payment-option-sub   { font-size: 12px; color: var(--text-light); margin-top: 2px; }

        /* Order summary card */
        .summary-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            position: sticky;
            top: 90px;
        }
        .summary-header {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
            font-size: 16px; font-weight: 800;
            color: var(--text-dark);
        }
        .summary-body { padding: 20px 24px; }

        .summary-restaurant {
            display: flex; align-items: center; gap: 12px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
            margin-bottom: 16px;
        }
        .summary-rest-img {
            width: 48px; height: 48px;
            border-radius: 10px; object-fit: cover;
            background: var(--border);
        }
        .summary-rest-name { font-size: 14px; font-weight: 700; }
        .summary-rest-type { font-size: 12px; color: var(--text-light); }

        .summary-item {
            display: flex; justify-content: space-between;
            align-items: flex-start;
            font-size: 13.5px; color: var(--text-mid);
            padding: 6px 0;
        }
        .summary-item-name { flex: 1; padding-right: 8px; }
        .summary-item-price { font-weight: 600; white-space: nowrap; }

        .summary-divider { height: 1px; background: var(--border); margin: 12px 0; }

        .summary-row {
            display: flex; justify-content: space-between;
            font-size: 13.5px; color: var(--text-mid);
            padding: 5px 0;
        }
        .summary-row span:last-child { font-weight: 600; }
        .summary-row.total {
            font-size: 17px; font-weight: 800;
            color: var(--text-dark);
            border-top: 2px solid var(--border);
            margin-top: 8px; padding-top: 14px;
        }
        .summary-row.total span:last-child { color: var(--primary); }

        .place-order-btn {
            display: block; width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff; border: none; border-radius: 12px;
            font-size: 16px; font-weight: 800;
            cursor: pointer; transition: all 0.2s;
            margin-top: 20px;
            box-shadow: 0 4px 16px rgba(200,2,56,0.3);
        }
        .place-order-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(200,2,56,0.4);
        }
        .place-order-btn:disabled {
            opacity: 0.7; cursor: not-allowed; transform: none;
        }

        .security-note {
            display: flex; align-items: center; justify-content: center; gap: 6px;
            font-size: 12px; color: var(--text-light);
            margin-top: 12px;
        }

        @media (max-width: 900px) {
            .checkout-page { grid-template-columns: 1fr; }
            .summary-card  { position: static; }
            .form-row      { grid-template-columns: 1fr; }
        }
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
            </a>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <div class="nav-user-pill">
                    <div class="nav-avatar">${sessionScope.loggedInUser.firstName.substring(0,1).toUpperCase()}</div>
                    Hi, ${sessionScope.loggedInUser.firstName}
                </div>
            </c:if>
        </div>
    </div>
</nav>

<!-- CHECKOUT STEPS -->
<div class="checkout-steps">
    <div class="step done">
        <div class="step-num">✓</div>
        <span>Cart</span>
    </div>
    <div class="step-line done"></div>
    <div class="step active">
        <div class="step-num">2</div>
        <span>Checkout</span>
    </div>
    <div class="step-line"></div>
    <div class="step pending">
        <div class="step-num">3</div>
        <span>Confirmation</span>
    </div>
</div>

<!-- MAIN CONTENT -->
<form action="${pageContext.request.contextPath}/order"
      method="post" id="checkoutForm">
<div class="checkout-page">

    <!-- LEFT: Delivery + Payment -->
    <div>

        <!-- Delivery Address -->
        <div class="checkout-card" style="margin-bottom:24px;">
            <div class="checkout-card-header">
                <div class="checkout-card-icon">📍</div>
                <div>
                    <div class="checkout-card-title">Delivery Address</div>
                </div>
            </div>
            <div class="checkout-card-body">

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input class="form-input" type="text"
                               value="${sessionScope.loggedInUser.username}"
                               readonly style="background:#f8f8fc;cursor:not-allowed;">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone</label>
                        <input class="form-input" type="tel"
                               value="${not empty sessionScope.loggedInUser.phone ? sessionScope.loggedInUser.phone : ''}"
                               readonly style="background:#f8f8fc;cursor:not-allowed;">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="deliveryAddress">
                        Delivery Address <span style="color:#dc2626;">*</span>
                    </label>
                    <textarea class="form-textarea"
                              id="deliveryAddress" name="deliveryAddress"
                              rows="3"
                              placeholder="Enter your full delivery address including flat/house no, street, area, city, pincode..."
                              required>${not empty sessionScope.loggedInUser.address ? sessionScope.loggedInUser.address : ''}</textarea>
                </div>

                <div class="form-group" style="margin-bottom:0;">
                    <label class="form-label" for="specialNotes">
                        Special Instructions <span style="color:var(--text-light);font-weight:400;">(optional)</span>
                    </label>
                    <input class="form-input" type="text"
                           id="specialNotes" name="specialNotes"
                           placeholder="e.g. Leave at door, extra napkins, no onions...">
                </div>
            </div>
        </div>

        <!-- Payment Method -->
        <div class="checkout-card">
            <div class="checkout-card-header">
                <div class="checkout-card-icon">💳</div>
                <div>
                    <div class="checkout-card-title">Payment Method</div>
                </div>
            </div>
            <div class="checkout-card-body">
                <div class="payment-options">

                    <label class="payment-option selected" id="cod-option">
                        <input type="radio" name="paymentMode"
                               value="CASH_ON_DELIVERY" checked
                               onchange="selectPayment(this, 'cod-option')">
                        <span class="payment-option-icon">💵</span>
                        <div>
                            <div class="payment-option-label">Cash on Delivery</div>
                            <div class="payment-option-sub">Pay when your order arrives</div>
                        </div>
                    </label>

                    <label class="payment-option" id="upi-option">
                        <input type="radio" name="paymentMode"
                               value="UPI"
                               onchange="selectPayment(this, 'upi-option')">
                        <span class="payment-option-icon">📱</span>
                        <div>
                            <div class="payment-option-label">UPI</div>
                            <div class="payment-option-sub">GPay, PhonePe, Paytm, BHIM</div>
                        </div>
                    </label>

                    <label class="payment-option" id="online-option">
                        <input type="radio" name="paymentMode"
                               value="ONLINE"
                               onchange="selectPayment(this, 'online-option')">
                        <span class="payment-option-icon">💳</span>
                        <div>
                            <div class="payment-option-label">Card / Net Banking</div>
                            <div class="payment-option-sub">Visa, Mastercard, Rupay, NetBanking</div>
                        </div>
                    </label>

                </div>
            </div>
        </div>

    </div>

    <!-- RIGHT: Order Summary -->
    <div>
        <div class="summary-card">
            <div class="summary-header">Order Summary</div>
            <div class="summary-body">

                <!-- Restaurant -->
                <div class="summary-restaurant">
                    <img class="summary-rest-img"
                         src="${pageContext.request.contextPath}/images/${restaurant.imagePath}"
                         alt="${restaurant.name}"
                         onerror="this.src='${pageContext.request.contextPath}/images/default-restaurant.jpg'">
                    <div>
                        <div class="summary-rest-name">${restaurant.name}</div>
                        <div class="summary-rest-type">${restaurant.cuisineType}</div>
                    </div>
                </div>

                <!-- Items -->
                <c:forEach var="item" items="${cartItems}">
                    <div class="summary-item">
                        <span class="summary-item-name">
                            ${item.name}
                            <span style="color:var(--text-light);font-size:12px;">× ${item.quantity}</span>
                        </span>
                        <span class="summary-item-price">
                            ₹<fmt:formatNumber value="${item.lineTotal}" maxFractionDigits="0"/>
                        </span>
                    </div>
                </c:forEach>

                <div class="summary-divider"></div>

                <div class="summary-row">
                    <span>Item Total</span>
                    <span>₹<fmt:formatNumber value="${subtotal}" maxFractionDigits="0"/></span>
                </div>
                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span>₹<fmt:formatNumber value="${deliveryFee}" maxFractionDigits="0"/></span>
                </div>
                <div class="summary-row">
                    <span>GST (5%)</span>
                    <span>₹<fmt:formatNumber value="${tax}" maxFractionDigits="0"/></span>
                </div>
                <div class="summary-row total">
                    <span>Total</span>
                    <span>₹<fmt:formatNumber value="${total}" maxFractionDigits="0"/></span>
                </div>

                <button type="submit" class="place-order-btn" id="placeOrderBtn">
                    🎉 Place Order · ₹<fmt:formatNumber value="${total}" maxFractionDigits="0"/>
                </button>

                <div class="security-note">
                    🔒 &nbsp;Secure checkout · Your data is safe
                </div>

            </div>
        </div>
    </div>

</div>
</form>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
function selectPayment(radio, optionId) {
    document.querySelectorAll('.payment-option').forEach(opt => {
        opt.classList.remove('selected');
    });
    document.getElementById(optionId).classList.add('selected');
}

document.getElementById('checkoutForm').addEventListener('submit', function(e) {
    const addr = document.getElementById('deliveryAddress').value.trim();
    if (!addr) {
        e.preventDefault();
        window.TapFood.showToast('Please enter a delivery address.', 'error');
        document.getElementById('deliveryAddress').focus();
        return;
    }
    const btn = document.getElementById('placeOrderBtn');
    btn.textContent = '⏳ Placing your order...';
    btn.disabled    = true;
});
</script>
</body>
</html>

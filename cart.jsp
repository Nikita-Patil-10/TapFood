<%--
    cart.jsp — TapFood Cart Page
    Location: src/main/webapp/jsp/cart.jsp
    FIXED: +/- quantity fires exactly once, removes only when qty reaches 0
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
        .cart-page { max-width:1100px; margin:40px auto; padding:0 24px 60px; display:grid; grid-template-columns:1fr 360px; gap:32px; align-items:start; }
        .cart-panel { background:#fff; border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; }
        .cart-panel-header { padding:20px 24px; border-bottom:1px solid var(--border); display:flex; align-items:center; justify-content:space-between; }
        .cart-panel-title { font-size:18px; font-weight:800; color:var(--text-dark); }
        .clear-cart-btn { font-size:13px; color:#dc2626; font-weight:600; cursor:pointer; padding:6px 14px; border:1.5px solid #fecaca; border-radius:50px; transition:all 0.2s; background:none; }
        .clear-cart-btn:hover { background:#fef2f2; }
        .cart-item { display:grid; grid-template-columns:80px 1fr auto; gap:16px; padding:18px 24px; border-bottom:1px solid var(--border); align-items:center; transition:background 0.15s; }
        .cart-item:last-child { border-bottom:none; }
        .cart-item:hover { background:#fafafa; }
        .cart-item-img { width:80px; height:64px; border-radius:10px; object-fit:cover; background:#f0f0f5; }
        .cart-item-name { font-size:15px; font-weight:700; color:var(--text-dark); margin-bottom:4px; }
        .cart-item-rest { font-size:12px; color:var(--text-light); margin-bottom:6px; }
        .cart-item-price { font-size:14px; font-weight:700; color:var(--primary); }
        .diet-dot-sm { display:inline-block; width:10px; height:10px; border-radius:2px; border:1.5px solid #2d7a3a; position:relative; margin-right:4px; vertical-align:middle; }
        .diet-dot-sm.nonveg { border-color:#c0392b; }
        .diet-dot-sm::after { content:''; position:absolute; width:5px; height:5px; background:#2d7a3a; border-radius:50%; top:50%; left:50%; transform:translate(-50%,-50%); }
        .diet-dot-sm.nonveg::after { background:#c0392b; }

        /* Quantity controls */
        .qty-controls { display:flex; align-items:center; background:#fff; border:1.5px solid var(--border); border-radius:10px; overflow:hidden; }
        .qty-btn {
            width:36px; height:36px;
            display:flex; align-items:center; justify-content:center;
            font-size:20px; font-weight:700;
            cursor:pointer; border:none; background:none;
            color:var(--primary); flex-shrink:0;
            /* CRITICAL: prevent double-fire */
            user-select:none;
            -webkit-user-select:none;
        }
        .qty-btn:hover { background:rgba(200,2,56,0.07); }
        .qty-btn:active { background:rgba(200,2,56,0.15); }
        .qty-btn:disabled { color:#ccc; cursor:not-allowed; background:none; }
        .qty-display { min-width:36px; text-align:center; font-size:15px; font-weight:700; color:var(--text-dark); border-left:1px solid var(--border); border-right:1px solid var(--border); padding:4px 8px; }

        .remove-btn { margin-top:8px; font-size:12px; color:#dc2626; cursor:pointer; background:none; border:none; font-weight:600; display:block; width:100%; text-align:center; }
        .remove-btn:hover { text-decoration:underline; }

        /* Summary */
        .summary-card { background:#fff; border:1px solid var(--border); border-radius:var(--radius-lg); overflow:hidden; position:sticky; top:90px; }
        .summary-header { padding:18px 24px; border-bottom:1px solid var(--border); font-size:16px; font-weight:800; color:var(--text-dark); }
        .summary-body { padding:20px 24px; }
        .summary-row { display:flex; justify-content:space-between; align-items:center; font-size:14px; color:var(--text-mid); padding:8px 0; }
        .summary-row span:last-child { font-weight:700; }
        .summary-row.total { font-size:17px; font-weight:800; color:var(--text-dark); border-top:2px solid var(--border); margin-top:8px; padding-top:16px; }
        .summary-row.total span:last-child { color:var(--primary); font-size:20px; }
        .checkout-btn { display:block; width:100%; padding:15px; background:linear-gradient(135deg,var(--primary),var(--accent)); color:#fff; border:none; border-radius:12px; font-size:16px; font-weight:800; cursor:pointer; transition:all 0.2s; margin-top:20px; text-align:center; text-decoration:none; box-shadow:0 4px 16px rgba(200,2,56,0.3); }
        .checkout-btn:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(200,2,56,0.4); }
        .continue-link { display:block; text-align:center; margin-top:14px; font-size:13px; color:var(--text-light); }
        .continue-link:hover { color:var(--primary); }
        .empty-cart { text-align:center; padding:80px 40px; }
        .empty-cart-icon { font-size:72px; margin-bottom:20px; display:block; }
        .empty-cart h3 { font-size:22px; font-weight:800; margin-bottom:8px; }
        .empty-cart p { color:var(--text-light); margin-bottom:28px; font-size:15px; }
        .cart-page-header { max-width:1100px; margin:0 auto; padding:28px 24px 0; }
        .cart-page-header h1 { font-size:28px; font-weight:900; letter-spacing:-0.5px; color:var(--text-dark); }
        @media(max-width:900px){ .cart-page{grid-template-columns:1fr;} .summary-card{position:static;} }
    </style>
</head>
<body>

<nav class="navbar" id="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">
            <div class="nav-logo-icon">🍔</div>
            <span class="nav-logo-text">TapFood</span>
        </a>
        <div class="nav-actions" style="margin-left:auto;">
            <a href="${pageContext.request.contextPath}/cart" class="nav-cart-btn">
                🛒 Cart
                <c:if test="${cartCount > 0}"><span class="cart-badge">${cartCount}</span></c:if>
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

<div class="cart-page-header">
    <h1>🛒 Your Cart</h1>
    <p style="font-size:14px;color:var(--text-light);margin-top:4px;">
        <a href="${pageContext.request.contextPath}/home" style="color:var(--text-light);">Home</a> › Cart
        <c:if test="${cartCount > 0}"> — ${cartCount} item${cartCount ne 1 ? 's' : ''}</c:if>
    </p>
</div>

<div class="cart-page" id="cartPage">
    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="cart-panel" style="grid-column:1/-1;">
                <div class="empty-cart">
                    <span class="empty-cart-icon">🛒</span>
                    <h3>Your cart is empty</h3>
                    <p>Looks like you haven't added anything yet.</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn-primary">Browse Restaurants →</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="cart-panel" id="cartItemsPanel">
                <div class="cart-panel-header">
                    <div class="cart-panel-title">
                        Order from <span style="color:var(--primary);">${cartItems[0].restaurantName}</span>
                    </div>
                    <button class="clear-cart-btn" id="clearCartBtn">🗑 Clear All</button>
                </div>
                <div id="cartItemsList">
                    <c:forEach var="item" items="${cartItems}">
                        <%-- Store unit price as data attribute for local recalculation --%>
                        <div class="cart-item"
                             id="row-${item.cartId}"
                             data-cart-id="${item.cartId}"
                             data-unit-price="${item.price}"
                             data-qty="${item.quantity}">

                            <img class="cart-item-img"
                                 src="${pageContext.request.contextPath}/images/${item.image}"
                                 alt="${item.name}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">

                            <div>
                                <div style="display:flex;align-items:center;margin-bottom:4px;">
                                    <span class="diet-dot-sm ${item.veg ? '' : 'nonveg'}"></span>
                                    <span class="cart-item-name">${item.name}</span>
                                </div>
                                <div class="cart-item-rest">${item.restaurantName}</div>
                                <div class="cart-item-price" id="price-${item.cartId}">
                                    ₹<fmt:formatNumber value="${item.lineTotal}" maxFractionDigits="0"/>
                                </div>
                            </div>

                            <div style="text-align:right;">
                                <div class="qty-controls">
                                    <%-- Use data attributes, NOT inline onclick with computed values --%>
                                    <button class="qty-btn btn-minus"
                                            data-cart-id="${item.cartId}"
                                            type="button">−</button>
                                    <div class="qty-display" id="qty-${item.cartId}">${item.quantity}</div>
                                    <button class="qty-btn btn-plus"
                                            data-cart-id="${item.cartId}"
                                            type="button">+</button>
                                </div>
                                <button class="remove-btn btn-remove"
                                        data-cart-id="${item.cartId}"
                                        type="button">Remove</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div>
                <div class="summary-card" id="summaryCard">
                    <div class="summary-header">Price Details</div>
                    <div class="summary-body">
                        <div class="summary-row">
                            <span>Item Total</span>
                            <span id="subtotalDisplay">₹<fmt:formatNumber value="${subtotal}" maxFractionDigits="0"/></span>
                        </div>
                        <div class="summary-row">
                            <span>Delivery Fee</span>
                            <span id="deliveryDisplay">₹<fmt:formatNumber value="${deliveryFee}" maxFractionDigits="0"/></span>
                        </div>
                        <div class="summary-row">
                            <span>GST (5%)</span>
                            <span id="taxDisplay">₹<fmt:formatNumber value="${tax}" maxFractionDigits="0"/></span>
                        </div>
                        <div class="summary-row total">
                            <span>Total</span>
                            <span id="totalDisplay">₹<fmt:formatNumber value="${total}" maxFractionDigits="0"/></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/checkout" class="checkout-btn">Proceed to Checkout →</a>
                        <a href="${pageContext.request.contextPath}/home" class="continue-link">+ Add more items</a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
var CTX = '${pageContext.request.contextPath}';

/*
 * ─── QUANTITY UPDATE ────────────────────────────────────────
 * Key fix: use a "busy" flag per button to prevent double-fire.
 * Only one request fires per click, no matter how fast user clicks.
 */

/* Track which cartIds are currently being updated */
var busyItems = {};

function setQtyBusy(cartId, busy) {
    busyItems[cartId] = busy;
    var plusBtn  = document.querySelector('.btn-plus[data-cart-id="' + cartId + '"]');
    var minusBtn = document.querySelector('.btn-minus[data-cart-id="' + cartId + '"]');
    if (plusBtn)  plusBtn.disabled  = busy;
    if (minusBtn) minusBtn.disabled = busy;
}

function getCurrentQty(cartId) {
    var el = document.getElementById('qty-' + cartId);
    return el ? parseInt(el.textContent, 10) : 1;
}

function doUpdateQty(cartId, newQty) {
    /* Guard: ignore if already processing this item */
    if (busyItems[cartId]) return;

    if (newQty < 1) {
        /* qty would go to 0 — remove item instead */
        doRemoveItem(cartId);
        return;
    }
    if (newQty > 10) {
        showToast('Maximum 10 items allowed.', 'error');
        return;
    }

    setQtyBusy(cartId, true);

    fetch(CTX + '/cart', {
        method:  'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body:    'action=update&cartId=' + cartId + '&quantity=' + newQty
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
        if (data.success) {
            /* Update displayed quantity */
            var qtyEl = document.getElementById('qty-' + cartId);
            if (qtyEl) qtyEl.textContent = newQty;

            /* Update the row's data-qty so next click reads correct value */
            var row = document.getElementById('row-' + cartId);
            if (row) {
                row.setAttribute('data-qty', newQty);
                /* Recalculate line price */
                var unitPrice = parseFloat(row.getAttribute('data-unit-price')) || 0;
                var priceEl   = document.getElementById('price-' + cartId);
                if (priceEl) priceEl.textContent = '₹' + Math.round(unitPrice * newQty);
            }

            refreshSummary();
        } else {
            showToast(data.message || 'Could not update quantity.', 'error');
        }
    })
    .catch(function (err) {
        showToast('Network error. Try again.', 'error');
    })
    .finally(function () {
        setQtyBusy(cartId, false);
    });
}

function doRemoveItem(cartId) {
    if (busyItems[cartId]) return;
    setQtyBusy(cartId, true);

    fetch(CTX + '/cart', {
        method:  'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body:    'action=remove&cartId=' + cartId
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
        if (data.success) {
            var row = document.getElementById('row-' + cartId);
            if (row) {
                row.style.transition = 'opacity 0.3s';
                row.style.opacity    = '0';
                setTimeout(function () {
                    row.remove();
                    refreshSummary();
                    if (document.querySelectorAll('.cart-item').length === 0) {
                        location.reload();
                    }
                }, 300);
            }
        } else {
            showToast(data.message || 'Could not remove item.', 'error');
            setQtyBusy(cartId, false);
        }
    })
    .catch(function () {
        showToast('Network error.', 'error');
        setQtyBusy(cartId, false);
    });
}

/*
 * ─── ATTACH BUTTON HANDLERS (single delegation on parent) ───
 * Using event delegation on the list container — only ONE handler
 * for ALL buttons. This completely prevents duplicate handlers.
 */
var cartList = document.getElementById('cartItemsList');
if (cartList) {
    cartList.addEventListener('click', function (e) {
        var btn = e.target;

        if (btn.classList.contains('btn-plus')) {
            e.preventDefault();
            var cartId = btn.getAttribute('data-cart-id');
            var curQty = getCurrentQty(cartId);
            doUpdateQty(cartId, curQty + 1);

        } else if (btn.classList.contains('btn-minus')) {
            e.preventDefault();
            var cartId = btn.getAttribute('data-cart-id');
            var curQty = getCurrentQty(cartId);
            doUpdateQty(cartId, curQty - 1);  /* goes to doRemoveItem if curQty-1 < 1 */

        } else if (btn.classList.contains('btn-remove')) {
            e.preventDefault();
            var cartId = btn.getAttribute('data-cart-id');
            doRemoveItem(cartId);
        }
    });
}

/* Clear cart button */
var clearBtn = document.getElementById('clearCartBtn');
if (clearBtn) {
    clearBtn.addEventListener('click', function () {
        if (!confirm('Remove all items from cart?')) return;
        fetch(CTX + '/cart', {
            method:  'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body:    'action=clear'
        }).then(function () { location.reload(); });
    });
}

/* ─── Summary recalculation ─────────────────────────────── */
function refreshSummary() {
    var subtotal = 0;
    document.querySelectorAll('[id^="price-"]').forEach(function (el) {
        var val = parseInt(el.textContent.replace('₹','').replace(',',''));
        if (!isNaN(val)) subtotal += val;
    });
    var delivery = subtotal > 0 ? 30 : 0;
    var tax      = Math.round(subtotal * 0.05);
    var total    = subtotal + delivery + tax;

    var s  = document.getElementById('subtotalDisplay');
    var d  = document.getElementById('deliveryDisplay');
    var t  = document.getElementById('taxDisplay');
    var tt = document.getElementById('totalDisplay');
    if (s)  s.textContent  = '₹' + subtotal;
    if (d)  d.textContent  = '₹' + delivery;
    if (t)  t.textContent  = '₹' + tax;
    if (tt) tt.textContent = '₹' + total;
}

/* ─── Toast helper ───────────────────────────────────────── */
function showToast(msg, type) {
    var container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    var div = document.createElement('div');
    div.className = 'toast ' + (type === 'error' ? 'error' : 'success');
    div.innerHTML = (type === 'error' ? '❌' : '✅') + ' &nbsp;' + msg;
    container.appendChild(div);
    setTimeout(function () {
        div.style.transition = 'opacity 0.4s';
        div.style.opacity    = '0';
        setTimeout(function () { div.remove(); }, 400);
    }, 3000);
}
</script>
</body>
</html>

<%--
    restaurant.jsp — Restaurant Detail Page
    Location: src/main/webapp/jsp/restaurant.jsp
    FIXED: single-restaurant cart with confirmation popup
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
        :root {
            --r-primary:   ${restaurant.colorPrimary};
            --r-secondary: ${restaurant.colorSecondary};
            --r-gradient:  linear-gradient(135deg, ${restaurant.colorPrimary}, ${restaurant.colorSecondary});
        }
        .rest-hero { background: var(--r-gradient); padding: 0; position: relative; overflow: hidden; }
        .rest-hero-overlay { background: rgba(0,0,0,0.45); padding: 0 24px 0; }
        .rest-hero-img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; opacity: 0.35; }
        .cat-nav { position: sticky; top: 68px; z-index: 100; background: #fff; border-bottom: 2px solid var(--border); overflow-x: auto; scrollbar-width: none; }
        .cat-nav::-webkit-scrollbar { display: none; }
        .cat-nav-inner { display: flex; gap: 4px; max-width: 1280px; margin: 0 auto; padding: 0 24px; }
        .cat-nav-item { padding: 14px 18px; font-size: 13.5px; font-weight: 600; color: var(--text-mid); white-space: nowrap; border-bottom: 3px solid transparent; transition: all 0.2s; text-decoration: none; display: block; }
        .cat-nav-item:hover { color: var(--r-primary); }
        .menu-item-card { display: grid; grid-template-columns: 1fr 120px; gap: 16px; padding: 20px 0; border-bottom: 1px solid var(--border); align-items: center; }
        .menu-item-card:last-child { border-bottom: none; }
        .add-btn { background: #fff; border: 2px solid var(--r-primary); color: var(--r-primary); border-radius: 8px; padding: 8px 22px; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s; width: 100%; margin-top: 10px; }
        .add-btn:hover { background: var(--r-primary); color: #fff; transform: scale(1.03); }
        .add-btn:disabled { border-color: #ccc; color: #ccc; cursor: not-allowed; transform: none; }
        .bestseller-tag { display: inline-flex; align-items: center; gap: 4px; background: #fff4e0; color: #b45309; font-size: 10px; font-weight: 800; padding: 3px 9px; border-radius: 4px; letter-spacing: 0.5px; text-transform: uppercase; margin-bottom: 6px; }
        .diet-dot { width: 14px; height: 14px; border-radius: 3px; display: inline-flex; align-items: center; justify-content: center; flex-shrink: 0; margin-right: 6px; }
        .diet-dot.veg { border: 2px solid #2d7a3a; }
        .diet-dot.veg .dot { background: #2d7a3a; }
        .diet-dot.nonveg { border: 2px solid #c0392b; }
        .diet-dot.nonveg .dot { background: #c0392b; }
        .dot { width: 6px; height: 6px; border-radius: 50%; }
        .floating-cart { position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%); z-index: 500; width: calc(100% - 48px); max-width: 520px; background: var(--r-gradient); color: #fff; border-radius: 16px; padding: 16px 20px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 8px 32px rgba(0,0,0,0.25); cursor: pointer; transition: transform 0.3s; text-decoration: none; }
        .floating-cart:hover { transform: translateX(-50%) translateY(-2px); }
        .floating-cart.hidden { display: none; }

        /* ── Restaurant Switch Popup ── */
        .popup-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:9000; align-items:center; justify-content:center; }
        .popup-overlay.show { display:flex; }
        .popup-box { background:#fff; border-radius:20px; padding:32px; max-width:420px; width:90%; text-align:center; box-shadow:0 20px 60px rgba(0,0,0,0.2); animation:popIn 0.25s ease; }
        @keyframes popIn { from{transform:scale(0.85);opacity:0;} to{transform:scale(1);opacity:1;} }
        .popup-icon { font-size:48px; margin-bottom:12px; }
        .popup-title { font-size:18px; font-weight:800; color:var(--text-dark); margin-bottom:8px; }
        .popup-msg { font-size:14px; color:var(--text-mid); line-height:1.6; margin-bottom:24px; }
        .popup-btns { display:flex; gap:12px; }
        .popup-btn-cancel { flex:1; padding:12px; border:1.5px solid var(--border); border-radius:10px; font-size:14px; font-weight:600; cursor:pointer; background:#fff; color:var(--text-dark); transition:all 0.2s; }
        .popup-btn-cancel:hover { border-color:var(--text-mid); }
        .popup-btn-confirm { flex:1; padding:12px; background:linear-gradient(135deg,var(--primary),var(--accent)); color:#fff; border:none; border-radius:10px; font-size:14px; font-weight:700; cursor:pointer; transition:all 0.2s; }
        .popup-btn-confirm:hover { opacity:0.9; }
    </style>
</head>
<body>

<!-- RESTAURANT SWITCH POPUP -->
<div class="popup-overlay" id="switchPopup">
    <div class="popup-box">
        <div class="popup-icon">🔄</div>
        <div class="popup-title">Start a new cart?</div>
        <div class="popup-msg">
            Your cart has items from <strong id="popupOldRest">another restaurant</strong>.<br>
            Adding this item will clear your current cart.
        </div>
        <div class="popup-btns">
            <button class="popup-btn-cancel" id="popupCancel">Keep Current Cart</button>
            <button class="popup-btn-confirm" id="popupConfirm">Clear & Add Item</button>
        </div>
    </div>
</div>

<nav class="navbar" id="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">
            <div class="nav-logo-icon">🍔</div>
            <span class="nav-logo-text">TapFood</span>
        </a>
        <div class="nav-location">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
            Bengaluru
        </div>
        <form class="nav-search" action="${pageContext.request.contextPath}/search" method="get">
            <svg class="nav-search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="text" name="q" placeholder="Search restaurants..." autocomplete="off">
            <button type="submit" class="nav-search-btn">Search</button>
        </form>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/cart" class="nav-cart-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
                Cart
                <c:if test="${not empty sessionScope.cartCount and sessionScope.cartCount > 0}">
                    <span class="cart-badge" id="navCartBadge">${sessionScope.cartCount}</span>
                </c:if>
            </a>
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <div class="nav-user-pill">
                        <div class="nav-avatar">${sessionScope.loggedInUser.firstName.substring(0,1).toUpperCase()}</div>
                        Hi, ${sessionScope.loggedInUser.firstName}
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="nav-btn nav-btn-outline">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="nav-btn nav-btn-outline">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="nav-btn nav-btn-primary">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<section class="rest-hero">
    <img class="rest-hero-img" src="${pageContext.request.contextPath}/images/${restaurant.imagePath}" alt="${restaurant.name}" onerror="this.style.display='none'">
    <div class="rest-hero-overlay">
        <div style="max-width:1280px;margin:0 auto;padding:40px 0 36px;position:relative;z-index:1;">
            <div style="display:flex;align-items:center;gap:8px;font-size:13px;color:rgba(255,255,255,0.7);margin-bottom:20px;">
                <a href="${pageContext.request.contextPath}/home" style="color:rgba(255,255,255,0.7);">Home</a>
                <span>›</span>
                <span style="color:#fff;">${restaurant.name}</span>
            </div>
            <div style="display:flex;align-items:flex-end;justify-content:space-between;gap:24px;flex-wrap:wrap;">
                <div>
                    <h1 style="font-size:clamp(28px,4vw,44px);font-weight:900;color:#fff;letter-spacing:-1px;margin-bottom:8px;">${restaurant.name}</h1>
                    <div style="font-size:15px;color:rgba(255,255,255,0.85);margin-bottom:12px;">${restaurant.cuisineType}</div>
                    <div style="display:flex;align-items:center;gap:16px;flex-wrap:wrap;">
                        <div style="display:flex;align-items:center;gap:6px;background:rgba(255,255,255,0.2);border-radius:8px;padding:6px 14px;">
                            <span style="color:#fbbf24;font-size:16px;">★</span>
                            <span style="font-weight:800;font-size:16px;color:#fff;">${restaurant.formattedRating}</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:6px;background:rgba(255,255,255,0.2);border-radius:8px;padding:6px 14px;">
                            <span>🕐</span><span style="font-weight:700;color:#fff;">${restaurant.deliveryTimeDisplay}</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:6px;background:rgba(255,255,255,0.2);border-radius:8px;padding:6px 14px;">
                            <span>🛵</span><span style="font-weight:700;color:#fff;">${restaurant.deliveryFeeDisplay} delivery</span>
                        </div>
                    </div>
                </div>
                <c:if test="${restaurant.hasOffer()}">
                    <div style="background:rgba(255,255,255,0.18);border:1.5px solid rgba(255,255,255,0.4);border-radius:12px;padding:12px 20px;text-align:center;">
                        <div style="font-size:11px;color:rgba(255,255,255,0.7);text-transform:uppercase;letter-spacing:1px;margin-bottom:4px;">Offer</div>
                        <div style="font-size:15px;font-weight:800;color:#fff;">🏷️ ${restaurant.offerText}</div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</section>

<nav class="cat-nav" id="catNav">
    <div class="cat-nav-inner">
        <c:forEach var="cat" items="${categories}">
            <a href="#cat-${cat.replaceAll('[^a-zA-Z0-9]','-')}" class="cat-nav-item">${cat}</a>
        </c:forEach>
    </div>
</nav>

<c:if test="${not empty restaurant.description}">
    <div style="background:#fff;border-bottom:1px solid var(--border);">
        <div style="max-width:1280px;margin:0 auto;padding:16px 24px;font-size:14px;color:var(--text-mid);">ℹ️ &nbsp;${restaurant.description}</div>
    </div>
</c:if>

<main>
<div style="max-width:1280px;margin:0 auto;padding:24px 24px 120px;display:grid;grid-template-columns:240px 1fr;gap:32px;">
    <aside>
        <div style="position:sticky;top:130px;">
            <div style="background:#fff;border:1px solid var(--border);border-radius:16px;overflow:hidden;">
                <div style="padding:16px 20px;font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:1px;border-bottom:1px solid var(--border);">Menu Categories</div>
                <c:forEach var="cat" items="${categories}">
                    <a href="#cat-${cat.replaceAll('[^a-zA-Z0-9]','-')}" class="sidebar-cat-link" style="display:block;padding:12px 20px;font-size:14px;font-weight:500;color:var(--text-mid);border-bottom:1px solid var(--border);transition:all 0.2s;text-decoration:none;">${cat}</a>
                </c:forEach>
            </div>
            <div style="margin-top:16px;background:#fff;border:1px solid var(--border);border-radius:16px;padding:20px;">
                <div style="font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:1px;margin-bottom:14px;">Restaurant Info</div>
                <div style="display:flex;flex-direction:column;gap:10px;font-size:13px;color:var(--text-mid);">
                    <div>📍 ${restaurant.address}, ${restaurant.city}</div>
                    <c:if test="${not empty restaurant.phone}"><div>📞 ${restaurant.phone}</div></c:if>
                    <div>🕐 ${restaurant.deliveryTimeDisplay}</div>
                    <div>🛵 ${restaurant.deliveryFeeDisplay} delivery</div>
                </div>
            </div>
        </div>
    </aside>

    <div>
        <c:if test="${empty menuItems}">
            <div style="text-align:center;padding:80px 20px;">
                <div style="font-size:64px;margin-bottom:16px;">🍽️</div>
                <h3 style="font-size:20px;font-weight:800;margin-bottom:8px;">Menu coming soon</h3>
            </div>
        </c:if>

        <c:forEach var="cat" items="${categories}">
            <section id="cat-${cat.replaceAll('[^a-zA-Z0-9]','-')}" class="menu-category-section" style="margin-bottom:40px;">
                <div style="display:flex;align-items:center;gap:12px;margin-bottom:4px;">
                    <h2 style="font-size:20px;font-weight:800;color:var(--text-dark);">${cat}</h2>
                    <div style="height:2px;flex:1;background:linear-gradient(90deg,${restaurant.colorPrimary}44,transparent);border-radius:1px;"></div>
                </div>
                <c:forEach var="item" items="${menuItems}">
                    <c:if test="${item.category eq cat}">
                        <div class="menu-item-card" id="item-${item.menuId}">
                            <div>
                                <div style="display:flex;align-items:center;gap:8px;margin-bottom:6px;">
                                    <div class="diet-dot ${item.veg ? 'veg' : 'nonveg'}"><div class="dot"></div></div>
                                    <c:if test="${item.bestseller}"><span class="bestseller-tag">🏆 Bestseller</span></c:if>
                                    <c:if test="${!item.available}"><span style="font-size:11px;background:#fef2f2;color:#dc2626;padding:3px 8px;border-radius:4px;font-weight:700;">UNAVAILABLE</span></c:if>
                                </div>
                                <h3 style="font-size:15px;font-weight:700;color:var(--text-dark);margin-bottom:6px;line-height:1.3;">${item.name}</h3>
                                <div style="font-size:15px;font-weight:800;color:${restaurant.colorPrimary};margin-bottom:8px;">${item.formattedPrice}</div>
                                <c:if test="${not empty item.description}">
                                    <p style="font-size:13px;color:var(--text-light);line-height:1.5;max-width:460px;">${item.description}</p>
                                </c:if>
                            </div>
                            <div style="text-align:center;">
                                <div style="width:120px;height:96px;border-radius:12px;overflow:hidden;background:#f5f5f5;margin-bottom:8px;">
                                    <img src="${pageContext.request.contextPath}/images/${item.image}" alt="${item.name}" style="width:100%;height:100%;object-fit:cover;" onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'" loading="lazy">
                                </div>
                                <button class="add-btn"
                                    data-menu-id="${item.menuId}"
                                    data-name="${item.name}"
                                    data-restaurant-id="${restaurant.restaurantId}"
                                    data-restaurant-name="${restaurant.name}"
                                    ${!item.available ? 'disabled' : ''}>
                                    ${item.available ? '+ ADD' : 'N/A'}
                                </button>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </section>
        </c:forEach>
    </div>
</div>
</main>

<a href="${pageContext.request.contextPath}/cart" class="floating-cart hidden" id="floatingCart">
    <div>
        <div style="font-size:12px;opacity:0.85;" id="fcCount">0 items</div>
        <div style="font-size:16px;font-weight:800;">View Cart</div>
    </div>
    <span style="font-size:13px;font-weight:600;opacity:0.9;">Go to Cart →</span>
</a>

<footer style="background:var(--text-dark);color:rgba(255,255,255,0.5);text-align:center;padding:20px;font-size:13px;">
    © 2026 TapFood Technologies Pvt. Ltd.
    <a href="${pageContext.request.contextPath}/home" style="color:#FDA501;margin-left:8px;">Back to Home</a>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
var CTX            = '${pageContext.request.contextPath}';
var IS_LOGGED_IN   = ${not empty sessionScope.loggedInUser};
var THIS_REST_ID   = ${restaurant.restaurantId};
var THIS_REST_NAME = '${restaurant.name}';
var cartCount      = ${not empty sessionScope.cartCount ? sessionScope.cartCount : 0};

/* Tracks the pending add action when popup is shown */
var pendingAdd = null;

/* ── Attach ONE click handler via delegation ─────────────── */
document.addEventListener('click', function (e) {
    var btn = e.target.closest('.add-btn');
    if (!btn || btn.disabled) return;
    e.preventDefault();

    if (!IS_LOGGED_IN) {
        window.location.href = CTX + '/login';
        return;
    }

    var menuId       = btn.getAttribute('data-menu-id');
    var name         = btn.getAttribute('data-name');
    var restaurantId = parseInt(btn.getAttribute('data-restaurant-id'), 10);

    /* Check if cart has items from a DIFFERENT restaurant */
    checkAndAdd(btn, menuId, name, restaurantId);
});

function checkAndAdd(btn, menuId, name, restaurantId) {
    /* Ask server what restaurant is currently in cart */
    fetch(CTX + '/cart?check=true', { method: 'GET' })
    .then(function(r) { return r.json(); })
    .catch(function() { return { cartRestaurantId: 0, cartCount: 0 }; })
    .then(function(data) {
        var cartRestId = data.cartRestaurantId || 0;
        if (cartRestId !== 0 && cartRestId !== restaurantId) {
            /* Different restaurant — show popup */
            pendingAdd = { btn: btn, menuId: menuId, name: name, restaurantId: restaurantId };
            document.getElementById('popupOldRest').textContent = data.cartRestaurantName || 'another restaurant';
            document.getElementById('switchPopup').classList.add('show');
        } else {
            /* Same restaurant or empty cart — add directly */
            performAdd(btn, menuId, name, restaurantId, false);
        }
    });
}

/* Popup buttons */
document.getElementById('popupCancel').addEventListener('click', function () {
    document.getElementById('switchPopup').classList.remove('show');
    pendingAdd = null;
});

document.getElementById('popupConfirm').addEventListener('click', function () {
    document.getElementById('switchPopup').classList.remove('show');
    if (pendingAdd) {
        performAdd(pendingAdd.btn, pendingAdd.menuId, pendingAdd.name, pendingAdd.restaurantId, true);
        pendingAdd = null;
    }
});

function performAdd(btn, menuId, name, restaurantId, clearFirst) {
    btn.textContent = '...';
    btn.disabled    = true;

    var body = 'action=add&menuId=' + menuId + '&restaurantId=' + restaurantId + '&quantity=1';
    if (clearFirst) body += '&clearFirst=true';

    fetch(CTX + '/cart', {
        method:  'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body:    body
    })
    .then(function (r) {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
    })
    .then(function (data) {
        if (data.success) {
            btn.textContent      = '✓ ADDED';
            btn.style.background = 'var(--r-primary)';
            btn.style.color      = '#fff';
            cartCount = data.cartCount;
            updateFloatingCart(cartCount);
            updateNavBadge(cartCount);
            showToast(name + ' added to cart!', false);
            setTimeout(function () {
                btn.textContent      = '+ ADD';
                btn.style.background = '';
                btn.style.color      = '';
                btn.disabled         = false;
            }, 1800);
        } else {
            btn.textContent = '+ ADD';
            btn.disabled    = false;
            showToast(data.message || 'Could not add item.', true);
        }
    })
    .catch(function (err) {
        btn.textContent = '+ ADD';
        btn.disabled    = false;
        showToast('Error: ' + err.message, true);
    });
}

function updateFloatingCart(count) {
    var bar = document.getElementById('floatingCart');
    var cnt = document.getElementById('fcCount');
    if (!bar) return;
    if (count > 0) {
        bar.classList.remove('hidden');
        cnt.textContent = count + (count === 1 ? ' item' : ' items');
    } else {
        bar.classList.add('hidden');
    }
}

function updateNavBadge(count) {
    var badge = document.getElementById('navCartBadge');
    if (count > 0) {
        if (!badge) {
            badge = document.createElement('span');
            badge.id = 'navCartBadge';
            badge.className = 'cart-badge';
            document.querySelector('.nav-cart-btn').appendChild(badge);
        }
        badge.textContent = count;
    } else if (badge) {
        badge.remove();
    }
}

function showToast(msg, isError) {
    var container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    var div = document.createElement('div');
    div.className = 'toast ' + (isError ? 'error' : 'success');
    div.innerHTML = (isError ? '❌' : '✅') + ' &nbsp;' + msg;
    container.appendChild(div);
    setTimeout(function () {
        div.style.transition = 'opacity 0.4s';
        div.style.opacity    = '0';
        setTimeout(function () { div.remove(); }, 400);
    }, 3000);
}

updateFloatingCart(cartCount);
</script>
</body>
</html>

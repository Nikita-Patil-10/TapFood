<%--
    home.jsp — TapFood Homepage
    Location: src/main/webapp/jsp/home.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'TapFood — Order Food Online'}</title>
    <meta name="description" content="Order food from the best restaurants near you. Fast delivery, great deals.">

    <!-- Preconnect for Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <!-- TapFood CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Inline critical theme vars -->
    <style>
        .hero-search-icon-svg { width:18px; height:18px; stroke:currentColor; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
    </style>
</head>
<body>

<!-- ══════════════════════════════════════════════════════════
     NAVBAR
══════════════════════════════════════════════════════════ -->
<nav class="navbar" id="navbar">
    <div class="nav-container">

        <!-- Logo -->
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">
            <div class="nav-logo-icon">🍔</div>
            <span class="nav-logo-text">TapFood</span>
        </a>

        <!-- Location -->
        <div class="nav-location">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
            </svg>
            Bengaluru
        </div>

        <!-- Search Bar -->
        <form class="nav-search" action="${pageContext.request.contextPath}/search" method="get">
            <svg class="nav-search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input type="text" name="q" placeholder="Search restaurants or cuisines..."
                   value="${not empty searchKeyword ? searchKeyword : ''}"
                   autocomplete="off">
            <button type="submit" class="nav-search-btn">Search</button>
        </form>

        <!-- Nav Actions -->
        <div class="nav-actions">
            <!-- Cart -->
            <a href="${pageContext.request.contextPath}/cart" class="nav-cart-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/>
                </svg>
                Cart
                <c:if test="${not empty sessionScope.cartCount and sessionScope.cartCount > 0}">
                    <span class="cart-badge">${sessionScope.cartCount}</span>
                </c:if>
            </a>

            <!-- Logged in vs Guest -->
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <a href="${pageContext.request.contextPath}/orders" class="nav-btn nav-btn-outline">
                        My Orders
                    </a>
                    <div class="nav-user-pill">
                        <div class="nav-avatar">${sessionScope.loggedInUser.firstName.substring(0,1).toUpperCase()}</div>
                        Hi, ${sessionScope.loggedInUser.firstName}
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="nav-btn nav-btn-outline">
                        Logout
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"    class="nav-btn nav-btn-outline">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="nav-btn nav-btn-primary">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</nav>

<!-- ══════════════════════════════════════════════════════════
     HERO BANNER (only on homepage, not search results)
══════════════════════════════════════════════════════════ -->
<c:if test="${activeFilter ne 'search'}">
<section class="hero">
    <div class="hero-inner">
        <div class="hero-content">

            <div class="hero-eyebrow">
                🔥 &nbsp; #1 Food Delivery in Bengaluru
            </div>

            <h1 class="hero-title">
                Hungry?<br>
                Order in<br>
                <span>minutes, not hours.</span>
            </h1>

            <p class="hero-subtitle">
                Discover the best food from top restaurants. Fast delivery, great deals, every single day.
            </p>

            <!-- Hero Search -->
            <form class="hero-search" action="${pageContext.request.contextPath}/search" method="get">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#aaa" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                </svg>
                <input type="text" name="q" placeholder="Search for biryani, pizza, sushi..." autocomplete="off">
                <button type="submit" class="hero-search-btn">Find Food</button>
            </form>

            <!-- Stats -->
            <div class="hero-stats">
                <div class="hero-stat">
                    <span class="hero-stat-value">${restaurantCount}+</span>
                    <span class="hero-stat-label">Restaurants</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">30</span>
                    <span class="hero-stat-label">Min Avg. Delivery</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">4.5★</span>
                    <span class="hero-stat-label">Avg. Rating</span>
                </div>
            </div>

        </div>

        <div class="hero-visual" aria-hidden="true">🍜</div>
    </div>
</section>
</c:if>

<!-- ══════════════════════════════════════════════════════════
     FLASH MESSAGES
══════════════════════════════════════════════════════════ -->
<c:if test="${not empty sessionScope.successMessage}">
    <div class="toast-container" id="flashToast">
        <div class="toast success">✅ &nbsp;${sessionScope.successMessage}</div>
    </div>
    <c:remove var="successMessage" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="toast-container" id="flashToast">
        <div class="toast error">❌ &nbsp;${sessionScope.errorMessage}</div>
    </div>
    <c:remove var="errorMessage" scope="session"/>
</c:if>

<!-- ══════════════════════════════════════════════════════════
     MAIN CONTENT
══════════════════════════════════════════════════════════ -->
<main>
<div class="section">

    <!-- ── Search Results Banner ────────────────────────────── -->
    <c:if test="${activeFilter eq 'search'}">
        <div class="search-results-banner" style="margin-top:32px;">
            <div class="search-results-text">
                ${searchMessage}
            </div>
            <a href="${pageContext.request.contextPath}/home" class="search-clear-btn">
                ✕ Clear Search
            </a>
        </div>
    </c:if>

    <!-- ── Section Header ───────────────────────────────────── -->
    <c:if test="${activeFilter ne 'search'}">
    <div class="section-header">
        <div>
            <h2 class="section-title">
                <c:choose>
                    <c:when test="${activeFilter eq 'top-rated'}">⭐ <span>Top Rated</span> Restaurants</c:when>
                    <c:when test="${activeFilter eq 'fast-delivery'}">⚡ <span>Fast Delivery</span> Near You</c:when>
                    <c:when test="${activeFilter eq 'veg'}">🥦 <span>Pure Veg</span> Restaurants</c:when>
                    <c:otherwise>🍽️ All <span>Restaurants</span></c:otherwise>
                </c:choose>
            </h2>
            <p class="section-subtitle">${restaurantCount} restaurants available</p>
        </div>
    </div>
    </c:if>

    <!-- ── Filter Tabs ───────────────────────────────────────── -->
    <c:if test="${activeFilter ne 'search'}">
    <div class="filters">
        <a href="${pageContext.request.contextPath}/home?filter=all"
           class="filter-btn ${activeFilter eq 'all' ? 'active' : ''}">
            🍽️ All
        </a>
        <a href="${pageContext.request.contextPath}/home?filter=top-rated"
           class="filter-btn ${activeFilter eq 'top-rated' ? 'active' : ''}">
            ⭐ Top Rated
        </a>
        <a href="${pageContext.request.contextPath}/home?filter=fast-delivery"
           class="filter-btn ${activeFilter eq 'fast-delivery' ? 'active' : ''}">
            ⚡ Fast Delivery
        </a>
        <a href="${pageContext.request.contextPath}/home?filter=veg"
           class="filter-btn ${activeFilter eq 'veg' ? 'active' : ''}">
            🥦 Pure Veg
        </a>
    </div>
    </c:if>

    <!-- ── Restaurant Grid ───────────────────────────────────── -->
    <div class="restaurant-grid">

        <c:choose>
            <c:when test="${empty restaurants}">
                <!-- Empty State -->
                <div class="empty-state">
                    <span class="empty-state-icon">🍽️</span>
                    <h3>No restaurants found</h3>
                    <p>
                        <c:choose>
                            <c:when test="${activeFilter eq 'search'}">
                                Try searching for something else like "biryani" or "pizza"
                            </c:when>
                            <c:otherwise>
                                No restaurants available for this filter right now.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/home" class="btn-primary">
                        View All Restaurants
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <!-- Restaurant Cards -->
                <c:forEach var="r" items="${restaurants}">
                    <a href="${pageContext.request.contextPath}/restaurant?id=${r.restaurantId}"
                       class="restaurant-card"
                       data-restaurant-id="${r.restaurantId}">

                        <!-- Image -->
                        <div class="card-img-wrap">
                            <img
                                src="${pageContext.request.contextPath}/images/${r.imagePath}"
                                alt="${r.name}"
                                onerror="this.src='${pageContext.request.contextPath}/images/default-restaurant.jpg'"
                                loading="lazy">

                            <!-- Offer Badge -->
                            <c:if test="${r.hasOffer()}">
                                <div class="card-offer-badge">🏷️ ${r.offerText}</div>
                            </c:if>

                            <!-- Delivery Time -->
                            <div class="card-delivery-pill">
                                🕐 ${r.deliveryTimeDisplay}
                            </div>
                        </div>

                        <!-- Body -->
                        <div class="card-body">

                            <div class="card-header-row">
                                <h3 class="card-name">${r.name}</h3>
                                <div class="card-rating">
                                    ★ ${r.formattedRating}
                                </div>
                            </div>

                            <div class="card-cuisine">${r.cuisineType}</div>

                            <!-- Dynamic color divider (restaurant's own theme color) -->
                            <div class="card-divider"
                                 style="background: linear-gradient(90deg, ${r.colorPrimary}, ${r.colorSecondary});"></div>

                            <div class="card-meta">
                                <div class="card-meta-item">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
                                    </svg>
                                    ${r.city}
                                </div>
                                <div class="card-meta-item">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                                    </svg>
                                    ${r.deliveryFeeDisplay} delivery
                                </div>
                                <div class="card-meta-item">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                                    </svg>
                                    ${r.deliveryTimeDisplay}
                                </div>
                            </div>

                        </div>

                        <!-- Hover Arrow -->
                        <div class="card-arrow"
                             style="background: linear-gradient(135deg, ${r.colorPrimary}, ${r.colorSecondary});">
                            →
                        </div>

                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </div><!-- /restaurant-grid -->

</div><!-- /section -->
</main>

<!-- ══════════════════════════════════════════════════════════
     FOOTER
══════════════════════════════════════════════════════════ -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-top">

            <div class="footer-brand">
                <span class="nav-logo-text">🍔 TapFood</span>
                <p>India's most loved food delivery platform. Order from the best restaurants near you, delivered fast and fresh.</p>
            </div>

            <div class="footer-col">
                <h4>Company</h4>
                <a href="#">About Us</a>
                <a href="#">Careers</a>
                <a href="#">Blog</a>
                <a href="#">Press</a>
            </div>

            <div class="footer-col">
                <h4>For Foodies</h4>
                <a href="${pageContext.request.contextPath}/home">Restaurants</a>
                <a href="${pageContext.request.contextPath}/orders">My Orders</a>
                <a href="#">Offers</a>
                <a href="#">TapFood Pro</a>
            </div>

            <div class="footer-col">
                <h4>Support</h4>
                <a href="#">Help Centre</a>
                <a href="#">Contact Us</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
            </div>

        </div>

        <div class="footer-bottom">
            <span>© 2026 TapFood Technologies Pvt. Ltd. All rights reserved.</span>
            <span>Made with ❤️ in Bengaluru, India</span>
        </div>
    </div>
</footer>

<!-- TapFood JS -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>

<!-- Auto-dismiss flash toasts -->
<script>
    const toast = document.getElementById('flashToast');
    if (toast) {
        setTimeout(() => {
            toast.style.transition = 'opacity 0.4s ease';
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 400);
        }, 3500);
    }
</script>

</body>
</html>

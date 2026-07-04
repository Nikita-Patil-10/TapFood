<%--
    search.jsp — Search Results Page
    Location: src/main/webapp/jsp/search.jsp
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
        .search-page {
            max-width: 1280px;
            margin: 0 auto;
            padding: 32px 24px 60px;
        }

        /* Search bar at top */
        .search-bar-big {
            display: flex;
            background: #fff;
            border: 2px solid var(--border);
            border-radius: 16px;
            padding: 6px 6px 6px 20px;
            align-items: center;
            gap: 12px;
            margin-bottom: 32px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .search-bar-big:focus-within {
            border-color: var(--primary);
            box-shadow: 0 4px 20px rgba(200,2,56,0.1);
        }
        .search-bar-big input {
            flex: 1;
            border: none;
            outline: none;
            font-size: 16px;
            font-family: inherit;
            color: var(--text-dark);
            background: transparent;
        }
        .search-bar-big input::placeholder { color: var(--text-light); }
        .search-bar-big button {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            white-space: nowrap;
        }
        .search-bar-big button:hover { opacity: 0.9; transform: scale(1.02); }

        /* Results summary */
        .search-summary {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .search-keyword {
            font-size: 22px;
            font-weight: 900;
            color: var(--text-dark);
            letter-spacing: -0.5px;
        }
        .search-keyword span { color: var(--primary); }
        .search-count {
            font-size: 13px;
            color: var(--text-light);
            background: var(--bg);
            padding: 6px 16px;
            border-radius: 50px;
            border: 1px solid var(--border);
            font-weight: 600;
        }
        .search-clear {
            font-size: 13px;
            font-weight: 600;
            color: var(--primary);
            padding: 6px 16px;
            border: 1.5px solid var(--primary);
            border-radius: 50px;
            transition: all 0.2s;
            text-decoration: none;
        }
        .search-clear:hover { background: var(--primary); color: #fff; }

        /* Section title */
        .result-section-title {
            font-size: 16px;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .result-section-title::after {
            content: '';
            flex: 1;
            height: 2px;
            background: linear-gradient(90deg, var(--border), transparent);
            border-radius: 1px;
        }

        /* Restaurant grid */
        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }

        /* Restaurant card */
        .restaurant-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid var(--border);
            transition: all 0.25s;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            text-decoration: none;
            display: block;
        }
        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.12);
            border-color: transparent;
        }
        .card-img-wrap {
            height: 180px;
            overflow: hidden;
            background: #f0f0f5;
            position: relative;
        }
        .card-img-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.4s;
        }
        .restaurant-card:hover .card-img-wrap img { transform: scale(1.06); }
        .card-offer-badge {
            position: absolute; top: 12px; left: 12px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #fff; font-size: 11px; font-weight: 700;
            padding: 5px 12px; border-radius: 50px;
        }
        .card-delivery-pill {
            position: absolute; bottom: 12px; right: 12px;
            background: rgba(0,0,0,0.72); backdrop-filter: blur(8px);
            color: #fff; font-size: 11px; font-weight: 600;
            padding: 5px 12px; border-radius: 50px;
        }
        .card-body { padding: 16px 18px 18px; }
        .card-header-row { display: flex; align-items: flex-start; justify-content: space-between; gap: 8px; margin-bottom: 4px; }
        .card-name { font-size: 16px; font-weight: 800; color: var(--text-dark); letter-spacing: -0.3px; }
        .card-rating { display: flex; align-items: center; gap: 4px; background: #2d7a3a; color: #fff; font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: 8px; white-space: nowrap; flex-shrink: 0; }
        .card-cuisine { font-size: 13px; color: var(--text-light); margin-bottom: 10px; font-weight: 500; }
        .card-divider { height: 2px; border-radius: 1px; margin-bottom: 10px; opacity: 0.6; }
        .card-meta { display: flex; align-items: center; gap: 14px; font-size: 12px; color: var(--text-mid); }
        .card-meta-item { display: flex; align-items: center; gap: 4px; font-weight: 500; }

        /* Menu item results */
        .menu-results-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 16px;
            margin-bottom: 40px;
        }
        .menu-result-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 14px;
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
        }
        .menu-result-card:hover {
            border-color: var(--primary);
            box-shadow: 0 4px 16px rgba(200,2,56,0.1);
            transform: translateY(-2px);
        }
        .menu-result-img {
            width: 64px; height: 56px;
            border-radius: 10px;
            object-fit: cover;
            background: #f0f0f5;
            flex-shrink: 0;
        }
        .menu-result-info { flex: 1; min-width: 0; }
        .menu-result-name { font-size: 14px; font-weight: 700; color: var(--text-dark); margin-bottom: 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .menu-result-rest { font-size: 12px; color: var(--text-light); margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .menu-result-price { font-size: 14px; font-weight: 800; color: var(--primary); }
        .diet-dot-sm { display: inline-block; width: 10px; height: 10px; border-radius: 2px; border: 1.5px solid #2d7a3a; position: relative; margin-right: 4px; vertical-align: middle; flex-shrink: 0; }
        .diet-dot-sm.nonveg { border-color: #c0392b; }
        .diet-dot-sm::after { content: ''; position: absolute; width: 5px; height: 5px; background: #2d7a3a; border-radius: 50%; top: 50%; left: 50%; transform: translate(-50%,-50%); }
        .diet-dot-sm.nonveg::after { background: #c0392b; }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 20px;
        }
        .empty-state-icon { font-size: 72px; margin-bottom: 20px; display: block; }
        .empty-state h3 { font-size: 22px; font-weight: 800; margin-bottom: 8px; }
        .empty-state p { color: var(--text-light); margin-bottom: 24px; font-size: 15px; line-height: 1.6; }

        /* Popular searches */
        .popular-tags { display: flex; flex-wrap: wrap; gap: 8px; justify-content: center; margin-top: 16px; }
        .popular-tag {
            padding: 8px 18px;
            border: 1.5px solid var(--border);
            border-radius: 50px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-mid);
            text-decoration: none;
            transition: all 0.2s;
        }
        .popular-tag:hover { border-color: var(--primary); color: var(--primary); }

        @media (max-width: 768px) {
            .restaurant-grid { grid-template-columns: 1fr; }
            .menu-results-grid { grid-template-columns: 1fr; }
            .search-keyword { font-size: 18px; }
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
        <div class="nav-location">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
            </svg>
            Bengaluru
        </div>
        <div class="nav-actions" style="margin-left:auto;">
            <a href="${pageContext.request.contextPath}/cart" class="nav-cart-btn">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/>
                </svg>
                Cart
                <c:if test="${not empty sessionScope.cartCount and sessionScope.cartCount > 0}">
                    <span class="cart-badge">${sessionScope.cartCount}</span>
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

<!-- MAIN -->
<div class="search-page">

    <!-- Big Search Bar -->
    <form action="${pageContext.request.contextPath}/search" method="get">
        <div class="search-bar-big">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#aaa" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input type="text" name="q"
                   value="${searchKeyword}"
                   placeholder="Search restaurants, cuisines, dishes..."
                   autofocus autocomplete="off">
            <button type="submit">Search</button>
        </div>
    </form>

    <!-- Results Summary -->
    <div class="search-summary">
        <div class="search-keyword">
            Results for <span>"${searchKeyword}"</span>
        </div>
        <div style="display:flex;align-items:center;gap:10px;">
            <span class="search-count">${restaurants.size()} restaurant${restaurants.size() ne 1 ? 's' : ''} found</span>
            <a href="${pageContext.request.contextPath}/home" class="search-clear">✕ Clear</a>
        </div>
    </div>

    <c:choose>

        <%-- ═══════════ NO RESULTS ═══════════ --%>
        <c:when test="${empty restaurants and empty menuResults}">
            <div class="empty-state">
                <span class="empty-state-icon">🔍</span>
                <h3>No results found</h3>
                <p>
                    We couldn't find anything for "<strong>${searchKeyword}</strong>".<br>
                    Try searching for something else.
                </p>
                <div class="popular-tags">
                    <a href="${pageContext.request.contextPath}/search?q=biryani"   class="popular-tag">🍛 Biryani</a>
                    <a href="${pageContext.request.contextPath}/search?q=pizza"     class="popular-tag">🍕 Pizza</a>
                    <a href="${pageContext.request.contextPath}/search?q=burger"    class="popular-tag">🍔 Burger</a>
                    <a href="${pageContext.request.contextPath}/search?q=chinese"   class="popular-tag">🥡 Chinese</a>
                    <a href="${pageContext.request.contextPath}/search?q=south indian" class="popular-tag">🥘 South Indian</a>
                    <a href="${pageContext.request.contextPath}/search?q=dessert"   class="popular-tag">🍰 Desserts</a>
                    <a href="${pageContext.request.contextPath}/search?q=coffee"    class="popular-tag">☕ Coffee</a>
                    <a href="${pageContext.request.contextPath}/search?q=sushi"     class="popular-tag">🍣 Sushi</a>
                </div>
                <div style="margin-top:24px;">
                    <a href="${pageContext.request.contextPath}/home" class="btn-primary">← Browse All Restaurants</a>
                </div>
            </div>
        </c:when>

        <%-- ═══════════ HAS RESULTS ═══════════ --%>
        <c:otherwise>

            <%-- Matching Dishes section --%>
            <c:if test="${not empty menuResults}">
                <div class="result-section-title">
                    🍽️ Matching Dishes (${menuResults.size()})
                </div>
                <div class="menu-results-grid">
                    <c:forEach var="item" items="${menuResults}">
                        <a href="${pageContext.request.contextPath}/restaurant?id=${item.restaurantId}"
                           class="menu-result-card">
                            <img class="menu-result-img"
                                 src="${pageContext.request.contextPath}/images/${item.image}"
                                 alt="${item.name}"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-food.jpg'">
                            <div class="menu-result-info">
                                <div style="display:flex;align-items:center;margin-bottom:3px;">
                                    <span class="diet-dot-sm ${item.veg ? '' : 'nonveg'}"></span>
                                    <span class="menu-result-name">${item.name}</span>
                                </div>
                                <div class="menu-result-rest">
                                    <c:forEach var="r" items="${restaurants}">
                                        <c:if test="${r.restaurantId eq item.restaurantId}">${r.name}</c:if>
                                    </c:forEach>
                                </div>
                                <div class="menu-result-price">${item.formattedPrice}</div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:if>

            <%-- Matching Restaurants section --%>
            <c:if test="${not empty restaurants}">
                <div class="result-section-title">
                    🏪 Restaurants (${restaurants.size()})
                </div>
                <div class="restaurant-grid">
                    <c:forEach var="r" items="${restaurants}">
                        <a href="${pageContext.request.contextPath}/restaurant?id=${r.restaurantId}"
                           class="restaurant-card">
                            <div class="card-img-wrap">
                                <img src="${pageContext.request.contextPath}/images/${r.imagePath}"
                                     alt="${r.name}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default-restaurant.jpg'"
                                     loading="lazy">
                                <c:if test="${r.hasOffer()}">
                                    <div class="card-offer-badge">🏷️ ${r.offerText}</div>
                                </c:if>
                                <div class="card-delivery-pill">🕐 ${r.deliveryTimeDisplay}</div>
                            </div>
                            <div class="card-body">
                                <div class="card-header-row">
                                    <h3 class="card-name">${r.name}</h3>
                                    <div class="card-rating">★ ${r.formattedRating}</div>
                                </div>
                                <div class="card-cuisine">${r.cuisineType}</div>
                                <div class="card-divider"
                                     style="background:linear-gradient(90deg,${r.colorPrimary},${r.colorSecondary});"></div>
                                <div class="card-meta">
                                    <div class="card-meta-item">📍 ${r.city}</div>
                                    <div class="card-meta-item">🛵 ${r.deliveryFeeDisplay}</div>
                                    <div class="card-meta-item">🕐 ${r.deliveryTimeDisplay}</div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:if>

        </c:otherwise>
    </c:choose>

</div>

<footer style="background:var(--text-dark);color:rgba(255,255,255,0.5);text-align:center;padding:20px;font-size:13px;margin-top:20px;">
    © 2026 TapFood Technologies Pvt. Ltd. &nbsp;·&nbsp;
    <a href="${pageContext.request.contextPath}/home" style="color:#FDA501;">Back to Home</a>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

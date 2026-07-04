<%--
    restaurants.jsp — Admin Restaurant List
    Location: src/main/webapp/jsp/admin/restaurants.jsp
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
        <a href="${pageContext.request.contextPath}/admin/restaurants" class="sidebar-link active"><span class="sidebar-link-icon">🏪</span> Restaurants</a>
        <a href="${pageContext.request.contextPath}/admin/menu" class="sidebar-link"><span class="sidebar-link-icon">🍽️</span> Menu Items</a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link"><span class="sidebar-link-icon">📦</span> Orders</a>
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
            <div class="topbar-title">🏪 Restaurants</div>
            <div class="topbar-sub">${restaurants.size()} restaurants total</div>
        </div>
        <div class="topbar-actions">
            <a href="${pageContext.request.contextPath}/admin/restaurants?action=add" class="topbar-btn topbar-btn-primary">+ Add Restaurant</a>
        </div>
    </div>

    <div class="page-content">

        <c:if test="${not empty sessionScope.adminMsg}">
            <div class="admin-alert ${sessionScope.adminMsg.startsWith('✅') ? 'success' : 'error'}">${sessionScope.adminMsg}</div>
            <c:remove var="adminMsg" scope="session"/>
        </c:if>

        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">All Restaurants</div>
                <div class="search-box">
                    <span class="search-box-icon">🔍</span>
                    <input type="text" id="searchInput" placeholder="Search restaurants..." oninput="filterTable()">
                </div>
            </div>
            <table class="admin-table" id="restTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Restaurant</th>
                        <th>Cuisine</th>
                        <th>Rating</th>
                        <th>Delivery</th>
                        <th>Theme</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${restaurants}">
                        <tr>
                            <td style="color:var(--text-light);font-size:12px;">#${r.restaurantId}</td>
                            <td>
                                <div style="display:flex;align-items:center;gap:10px;">
                                    <div style="width:36px;height:36px;border-radius:8px;overflow:hidden;background:#f0f0f5;flex-shrink:0;">
                                        <img src="${pageContext.request.contextPath}/images/${r.imagePath}"
                                             style="width:100%;height:100%;object-fit:cover;"
                                             onerror="this.style.display='none'">
                                    </div>
                                    <div>
                                        <div style="font-weight:700;font-size:13.5px;">${r.name}</div>
                                        <div style="font-size:11px;color:var(--text-light);">${r.city}</div>
                                    </div>
                                </div>
                            </td>
                            <td style="font-size:12.5px;color:var(--text-mid);">${r.cuisineType}</td>
                            <td>
                                <span style="background:#dcfce7;color:#15803d;padding:3px 8px;border-radius:6px;font-size:12px;font-weight:700;">
                                    ★ ${r.formattedRating}
                                </span>
                            </td>
                            <td style="font-size:12.5px;">${r.deliveryTimeDisplay} · ${r.deliveryFeeDisplay}</td>
                            <td>
                                <div style="display:flex;align-items:center;gap:6px;">
                                    <div style="width:16px;height:16px;border-radius:4px;background:${r.colorPrimary};border:1px solid rgba(0,0,0,0.1);"></div>
                                    <div style="width:16px;height:16px;border-radius:4px;background:${r.colorSecondary};border:1px solid rgba(0,0,0,0.1);"></div>
                                </div>
                            </td>
                            <td>
                                <span class="badge ${r.active ? 'badge-success' : 'badge-danger'}">
                                    ${r.active ? '● Active' : '○ Inactive'}
                                </span>
                            </td>
                            <td>
                                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                                    <a href="${pageContext.request.contextPath}/admin/restaurants?action=edit&id=${r.restaurantId}"
                                       class="action-btn btn-edit">✏️ Edit</a>
                                    <a href="${pageContext.request.contextPath}/admin/menu?restaurantId=${r.restaurantId}"
                                       class="action-btn btn-view">🍽️ Menu</a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/restaurants" style="display:inline;">
                                        <input type="hidden" name="action"   value="toggle">
                                        <input type="hidden" name="id"       value="${r.restaurantId}">
                                        <input type="hidden" name="isActive" value="${!r.active}">
                                        <button class="action-btn btn-toggle">${r.active ? '⏸ Disable' : '▶ Enable'}</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/restaurants"
                                          style="display:inline;"
                                          onsubmit="return confirm('Delete ${r.name}? This cannot be undone.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id"     value="${r.restaurantId}">
                                        <button class="action-btn btn-delete">🗑</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty restaurants}">
                        <tr><td colspan="8" style="text-align:center;padding:40px;color:var(--text-light);">No restaurants found. <a href="${pageContext.request.contextPath}/admin/restaurants?action=add" style="color:var(--primary);">Add one →</a></td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function filterTable() {
    var val   = document.getElementById('searchInput').value.toLowerCase();
    var rows  = document.querySelectorAll('#restTable tbody tr');
    rows.forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(val) ? '' : 'none';
    });
}
</script>
</body>
</html>

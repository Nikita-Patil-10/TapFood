<%--
    menu.jsp — Admin Menu Items List
    Location: src/main/webapp/jsp/admin/menu.jsp
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
        <a href="${pageContext.request.contextPath}/admin/menu" class="sidebar-link active"><span class="sidebar-link-icon">🍽️</span> Menu Items</a>
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
            <div class="topbar-title">🍽️ Menu Items</div>
            <div class="topbar-sub">${menuItems.size()} items</div>
        </div>
        <div class="topbar-actions">
            <a href="${pageContext.request.contextPath}/admin/menu?action=add" class="topbar-btn topbar-btn-primary">+ Add Menu Item</a>
        </div>
    </div>

    <div class="page-content">

        <c:if test="${not empty sessionScope.adminMsg}">
            <div class="admin-alert ${sessionScope.adminMsg.startsWith('✅') ? 'success' : 'error'}">${sessionScope.adminMsg}</div>
            <c:remove var="adminMsg" scope="session"/>
        </c:if>

        <!-- Filter by restaurant -->
        <div class="filter-bar">
            <a href="${pageContext.request.contextPath}/admin/menu"
               class="filter-tab ${empty filterRestId ? 'active' : ''}">All Restaurants</a>
            <c:forEach var="r" items="${restaurants}">
                <a href="${pageContext.request.contextPath}/admin/menu?restaurantId=${r.restaurantId}"
                   class="filter-tab ${filterRestId eq r.restaurantId ? 'active' : ''}">${r.name}</a>
            </c:forEach>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">Menu Items</div>
                <div class="search-box">
                    <span class="search-box-icon">🔍</span>
                    <input type="text" id="searchInput" placeholder="Search items..." oninput="filterTable()">
                </div>
            </div>
            <table class="admin-table" id="menuTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Item</th>
                        <th>Restaurant</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Type</th>
                        <th>Bestseller</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${menuItems}">
                        <tr>
                            <td style="color:var(--text-light);font-size:12px;">#${item.menuId}</td>
                            <td>
                                <div style="display:flex;align-items:center;gap:10px;">
                                    <div style="width:36px;height:36px;border-radius:8px;overflow:hidden;background:#f0f0f5;flex-shrink:0;">
                                        <img src="${pageContext.request.contextPath}/images/${item.image}"
                                             style="width:100%;height:100%;object-fit:cover;"
                                             onerror="this.style.display='none'">
                                    </div>
                                    <div>
                                        <div style="font-weight:700;font-size:13.5px;">${item.name}</div>
                                        <div style="font-size:11px;color:var(--text-light);max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">${item.description}</div>
                                    </div>
                                </div>
                            </td>
                            <td style="font-size:12.5px;">R#${item.restaurantId}</td>
                            <td><span class="badge badge-gray">${item.category}</span></td>
                            <td><strong>₹<fmt:formatNumber value="${item.price}" maxFractionDigits="0"/></strong></td>
                            <td>
                                <span class="badge ${item.veg ? 'badge-success' : 'badge-danger'}">
                                    ${item.veg ? '🟢 Veg' : '🔴 Non-Veg'}
                                </span>
                            </td>
                            <td>
                                <c:if test="${item.bestseller}">
                                    <span class="badge badge-warning">🏆 Yes</span>
                                </c:if>
                                <c:if test="${!item.bestseller}">
                                    <span style="color:var(--text-light);font-size:12px;">—</span>
                                </c:if>
                            </td>
                            <td>
                                <span class="badge ${item.available ? 'badge-success' : 'badge-danger'}">
                                    ${item.available ? '● Available' : '○ Unavailable'}
                                </span>
                            </td>
                            <td>
                                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                                    <a href="${pageContext.request.contextPath}/admin/menu?action=edit&id=${item.menuId}"
                                       class="action-btn btn-edit">✏️ Edit</a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/menu" style="display:inline;">
                                        <input type="hidden" name="action"      value="toggle">
                                        <input type="hidden" name="id"          value="${item.menuId}">
                                        <input type="hidden" name="isAvailable" value="${!item.available}">
                                        <button class="action-btn btn-toggle">${item.available ? '⏸ Hide' : '▶ Show'}</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/menu"
                                          style="display:inline;"
                                          onsubmit="return confirm('Delete ${item.name}?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id"     value="${item.menuId}">
                                        <button class="action-btn btn-delete">🗑</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty menuItems}">
                        <tr><td colspan="9" style="text-align:center;padding:40px;color:var(--text-light);">No menu items found. <a href="${pageContext.request.contextPath}/admin/menu?action=add" style="color:var(--primary);">Add one →</a></td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function filterTable() {
    var val  = document.getElementById('searchInput').value.toLowerCase();
    var rows = document.querySelectorAll('#menuTable tbody tr');
    rows.forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(val) ? '' : 'none';
    });
}
</script>
</body>
</html>

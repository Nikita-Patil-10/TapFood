<%--
    users.jsp — Admin Users List
    Location: src/main/webapp/jsp/admin/users.jsp
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
        <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link"><span class="sidebar-link-icon">📦</span> Orders</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link active"><span class="sidebar-link-icon">👥</span> Users</a>
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
            <div class="topbar-title">👥 Users</div>
            <div class="topbar-sub">${users.size()} registered users</div>
        </div>
    </div>

    <div class="page-content">

        <c:if test="${not empty sessionScope.adminMsg}">
            <div class="admin-alert ${sessionScope.adminMsg.startsWith('✅') ? 'success' : 'error'}">${sessionScope.adminMsg}</div>
            <c:remove var="adminMsg" scope="session"/>
        </c:if>

        <div class="table-card">
            <div class="table-card-header">
                <div class="table-card-title">All Users</div>
                <div class="search-box">
                    <span class="search-box-icon">🔍</span>
                    <input type="text" id="searchInput" placeholder="Search users..." oninput="filterTable()">
                </div>
            </div>
            <table class="admin-table" id="userTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Joined</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td style="color:var(--text-light);font-size:12px;">#${user.userId}</td>
                            <td>
                                <div style="display:flex;align-items:center;gap:10px;">
                                    <div style="width:32px;height:32px;background:linear-gradient(135deg,#C80238,#FDA501);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-size:13px;font-weight:800;flex-shrink:0;">
                                        ${user.firstName.substring(0,1).toUpperCase()}
                                    </div>
                                    <span style="font-weight:600;">${user.username}</span>
                                </div>
                            </td>
                            <td style="font-size:13px;color:var(--text-mid);">${user.email}</td>
                            <td style="font-size:13px;color:var(--text-mid);">${not empty user.phone ? user.phone : '—'}</td>
                            <td>
                                <span class="badge ${user.role eq 'ADMIN' ? 'badge-purple' : 'badge-info'}">
                                    ${user.role eq 'ADMIN' ? '👑 Admin' : '👤 Customer'}
                                </span>
                            </td>
                            <td>
                                <span class="badge ${user.active ? 'badge-success' : 'badge-danger'}">
                                    ${user.active ? '● Active' : '○ Inactive'}
                                </span>
                            </td>
                            <td style="font-size:12px;color:var(--text-light);">
                                <c:if test="${not empty user.createdDate}">
                                    ${user.createdDate.toString().substring(0,10)}
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${user.role ne 'ADMIN'}">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/users"
                                          style="display:inline;"
                                          onsubmit="return confirm('${user.active ? 'Deactivate' : 'Activate'} user ${user.username}?');">
                                        <input type="hidden" name="userId"   value="${user.userId}">
                                        <input type="hidden" name="isActive" value="${!user.active}">
                                        <button class="action-btn ${user.active ? 'btn-delete' : 'btn-success'}">
                                            ${user.active ? '⛔ Deactivate' : '✅ Activate'}
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${user.role eq 'ADMIN'}">
                                    <span style="font-size:12px;color:var(--text-light);">Protected</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr><td colspan="8" style="text-align:center;padding:40px;color:var(--text-light);">No users found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
function filterTable() {
    var val  = document.getElementById('searchInput').value.toLowerCase();
    var rows = document.querySelectorAll('#userTable tbody tr');
    rows.forEach(function(row) {
        row.style.display = row.textContent.toLowerCase().includes(val) ? '' : 'none';
    });
}
</script>
</body>
</html>

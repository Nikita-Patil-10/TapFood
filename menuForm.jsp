<%--
    menuForm.jsp — Add / Edit Menu Item
    Location: src/main/webapp/jsp/admin/menuForm.jsp
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
            <div class="topbar-title">${not empty menuItem ? '✏️ Edit Menu Item' : '➕ Add Menu Item'}</div>
            <div class="topbar-sub">
                <a href="${pageContext.request.contextPath}/admin/menu" style="color:var(--text-light);">Menu Items</a>
                › ${not empty menuItem ? menuItem.name : 'New Item'}
            </div>
        </div>
    </div>

    <div class="page-content">
        <div class="form-card">

            <form method="post" action="${pageContext.request.contextPath}/admin/menu">
                <input type="hidden" name="action" value="${not empty menuItem ? 'update' : 'add'}">
                <c:if test="${not empty menuItem}">
                    <input type="hidden" name="menuId" value="${menuItem.menuId}">
                </c:if>

                <div class="form-section-title">Item Details</div>
                <div class="form-grid" style="margin-bottom:16px;">

                    <div class="form-group">
                        <label class="form-label">Restaurant <span class="req">*</span></label>
                        <select class="form-select" name="restaurantId" required>
                            <option value="">-- Select Restaurant --</option>
                            <c:forEach var="r" items="${restaurants}">
                                <option value="${r.restaurantId}"
                                    ${not empty menuItem and menuItem.restaurantId eq r.restaurantId ? 'selected' : ''}>
                                    ${r.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Item Name <span class="req">*</span></label>
                        <input class="form-input" type="text" name="name" required
                               value="${not empty menuItem ? menuItem.name : ''}"
                               placeholder="e.g. Masala Dosa">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Price (₹) <span class="req">*</span></label>
                        <input class="form-input" type="number" name="price" min="0" step="0.5" required
                               value="${not empty menuItem ? menuItem.price : ''}">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Category <span class="req">*</span></label>
                        <input class="form-input" type="text" name="category" required
                               value="${not empty menuItem ? menuItem.category : ''}"
                               placeholder="e.g. Starters, Mains, Desserts">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Image File Name</label>
                        <input class="form-input" type="text" name="image"
                               value="${not empty menuItem ? menuItem.image : 'default-food.jpg'}"
                               placeholder="masala-dosa.jpg">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Spice Level</label>
                        <select class="form-select" name="spiceLevel">
                            <option value="MILD"       ${not empty menuItem and menuItem.spiceLevel eq 'MILD'       ? 'selected':''}>🟢 Mild</option>
                            <option value="MEDIUM"     ${not empty menuItem and menuItem.spiceLevel eq 'MEDIUM'     ? 'selected':''}>🟡 Medium</option>
                            <option value="HOT"        ${not empty menuItem and menuItem.spiceLevel eq 'HOT'        ? 'selected':''}>🔴 Hot</option>
                            <option value="EXTRA_HOT"  ${not empty menuItem and menuItem.spiceLevel eq 'EXTRA_HOT'  ? 'selected':''}>🌶 Extra Hot</option>
                        </select>
                    </div>

                    <div class="form-group form-full">
                        <label class="form-label">Description <span class="opt">(optional)</span></label>
                        <textarea class="form-textarea" name="description" rows="3"
                                  placeholder="Describe the dish — ingredients, taste, special preparation...">${not empty menuItem ? menuItem.description : ''}</textarea>
                    </div>

                </div>

                <div class="form-section-title" style="margin-top:8px;">Flags & Availability</div>
                <div style="display:flex;gap:28px;flex-wrap:wrap;margin-bottom:8px;">
                    <label class="form-check-row">
                        <input type="checkbox" name="isVeg" value="on"
                               ${not empty menuItem and menuItem.veg ? 'checked' : (empty menuItem ? 'checked' : '')}>
                        🟢 Vegetarian Item
                    </label>
                    <label class="form-check-row">
                        <input type="checkbox" name="isBestseller" value="on"
                               ${not empty menuItem and menuItem.bestseller ? 'checked' : ''}>
                        🏆 Mark as Bestseller
                    </label>
                    <label class="form-check-row">
                        <input type="checkbox" name="isAvailable" value="on"
                               ${empty menuItem or menuItem.available ? 'checked' : ''}>
                        ✅ Currently Available
                    </label>
                </div>

                <div class="submit-row">
                    <button type="submit" class="btn-submit">
                        ${not empty menuItem ? '💾 Update Item' : '➕ Add Item'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/menu" class="btn-cancel">Cancel</a>
                </div>
            </form>

        </div>
    </div>
</div>
</body>
</html>

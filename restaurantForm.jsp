<%--
    restaurantForm.jsp — Add / Edit Restaurant
    Location: src/main/webapp/jsp/admin/restaurantForm.jsp
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
            <div class="topbar-title">${not empty restaurant ? '✏️ Edit Restaurant' : '➕ Add Restaurant'}</div>
            <div class="topbar-sub">
                <a href="${pageContext.request.contextPath}/admin/restaurants" style="color:var(--text-light);">Restaurants</a>
                › ${not empty restaurant ? restaurant.name : 'New'}
            </div>
        </div>
    </div>

    <div class="page-content">
        <div class="form-card">

            <form method="post" action="${pageContext.request.contextPath}/admin/restaurants">
                <input type="hidden" name="action" value="${not empty restaurant ? 'update' : 'add'}">
                <c:if test="${not empty restaurant}">
                    <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
                </c:if>

                <!-- Basic Info -->
                <div class="form-section-title">Basic Information</div>
                <div class="form-grid" style="margin-bottom:16px;">
                    <div class="form-group">
                        <label class="form-label">Restaurant Name <span class="req">*</span></label>
                        <input class="form-input" type="text" name="name" required
                               value="${not empty restaurant ? restaurant.name : ''}"
                               placeholder="e.g. Dakshin Delight">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Cuisine Type <span class="req">*</span></label>
                        <input class="form-input" type="text" name="cuisineType" required
                               value="${not empty restaurant ? restaurant.cuisineType : ''}"
                               placeholder="e.g. South Indian, Italian">
                    </div>
                    <div class="form-group form-full">
                        <label class="form-label">Address <span class="req">*</span></label>
                        <input class="form-input" type="text" name="address" required
                               value="${not empty restaurant ? restaurant.address : ''}"
                               placeholder="Full street address">
                    </div>
                    <div class="form-group">
                        <label class="form-label">City</label>
                        <input class="form-input" type="text" name="city"
                               value="${not empty restaurant ? restaurant.city : 'Bengaluru'}"
                               placeholder="Bengaluru">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone <span class="opt">(optional)</span></label>
                        <input class="form-input" type="text" name="phone"
                               value="${not empty restaurant ? restaurant.phone : ''}"
                               placeholder="080-41234567">
                    </div>
                    <div class="form-group form-full">
                        <label class="form-label">Description <span class="opt">(optional)</span></label>
                        <textarea class="form-textarea" name="description" rows="3"
                                  placeholder="Brief description shown on restaurant page...">${not empty restaurant ? restaurant.description : ''}</textarea>
                    </div>
                </div>

                <!-- Delivery & Pricing -->
                <div class="form-section-title" style="margin-top:8px;">Delivery & Pricing</div>
                <div class="form-grid-3" style="margin-bottom:16px;">
                    <div class="form-group">
                        <label class="form-label">Rating (1.0–5.0)</label>
                        <input class="form-input" type="number" name="ratings" min="1" max="5" step="0.1"
                               value="${not empty restaurant ? restaurant.ratings : '4.0'}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Delivery Time (mins)</label>
                        <input class="form-input" type="number" name="deliveryTime" min="5" max="120"
                               value="${not empty restaurant ? restaurant.deliveryTime : '30'}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Delivery Fee (₹)</label>
                        <input class="form-input" type="number" name="deliveryFee" min="0" step="0.5"
                               value="${not empty restaurant ? restaurant.deliveryFee : '30'}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Min Order Amount (₹)</label>
                        <input class="form-input" type="number" name="minOrderAmount" min="0"
                               value="${not empty restaurant ? restaurant.minOrderAmount : '99'}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Image File Name <span class="opt">(optional)</span></label>
                        <input class="form-input" type="text" name="imagePath"
                               value="${not empty restaurant ? restaurant.imagePath : 'default-restaurant.jpg'}"
                               placeholder="restaurant-name.jpg">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Offer Text <span class="opt">(optional)</span></label>
                        <input class="form-input" type="text" name="offerText"
                               value="${not empty restaurant ? restaurant.offerText : ''}"
                               placeholder="e.g. 20% OFF above ₹299">
                    </div>
                </div>

                <!-- Theme Colors -->
                <div class="form-section-title" style="margin-top:8px;">Dynamic Theme Colors</div>
                <p style="font-size:12.5px;color:var(--text-light);margin-bottom:16px;">
                    These colors are applied to the restaurant's page, cards, and buttons automatically.
                </p>
                <div class="form-grid" style="margin-bottom:8px;">
                    <div class="form-group">
                        <label class="form-label">Primary Color</label>
                        <div class="color-preview">
                            <input type="color" name="colorPrimary" id="colorPrimary"
                                   value="${not empty restaurant ? restaurant.colorPrimary : '#C80238'}"
                                   oninput="document.getElementById('cp-hex').value=this.value">
                            <input class="form-input" type="text" id="cp-hex" placeholder="#C80238"
                                   value="${not empty restaurant ? restaurant.colorPrimary : '#C80238'}"
                                   oninput="document.getElementById('colorPrimary').value=this.value"
                                   style="flex:1;" maxlength="7">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Secondary Color</label>
                        <div class="color-preview">
                            <input type="color" name="colorSecondary" id="colorSecondary"
                                   value="${not empty restaurant ? restaurant.colorSecondary : '#FDA501'}"
                                   oninput="document.getElementById('cs-hex').value=this.value">
                            <input class="form-input" type="text" id="cs-hex" placeholder="#FDA501"
                                   value="${not empty restaurant ? restaurant.colorSecondary : '#FDA501'}"
                                   oninput="document.getElementById('colorSecondary').value=this.value"
                                   style="flex:1;" maxlength="7">
                        </div>
                    </div>
                </div>

                <!-- Live Preview -->
                <div style="margin-top:12px;margin-bottom:4px;">
                    <div id="themePreview" style="height:48px;border-radius:10px;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:14px;transition:background 0.3s;">
                        Theme Preview
                    </div>
                </div>

                <div class="submit-row">
                    <button type="submit" class="btn-submit">
                        ${not empty restaurant ? '💾 Update Restaurant' : '➕ Add Restaurant'}
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/restaurants" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function updatePreview() {
    var p = document.getElementById('colorPrimary').value;
    var s = document.getElementById('colorSecondary').value;
    document.getElementById('themePreview').style.background =
        'linear-gradient(135deg, ' + p + ', ' + s + ')';
}
document.getElementById('colorPrimary').addEventListener('input', updatePreview);
document.getElementById('colorSecondary').addEventListener('input', updatePreview);
updatePreview();
</script>
</body>
</html>

package com.tap.util;

/**
 * AppConstants.java
 * Location: src/main/java/com/tap/util/AppConstants.java
 */
public final class AppConstants {

    private AppConstants() {}

    // App Info
    public static final String APP_NAME     = "TapFood";
    public static final String APP_VERSION  = "1.0.0";
    public static final String APP_TAGLINE  = "Order food from the best restaurants near you";

    // Session Keys
    public static final String SESSION_USER        = "loggedInUser";
    public static final String SESSION_CART        = "cart";
    public static final String SESSION_CART_COUNT  = "cartCount";
    public static final String SESSION_RESTAURANT  = "currentRestaurant";
    public static final String SESSION_MSG_SUCCESS = "successMessage";
    public static final String SESSION_MSG_ERROR   = "errorMessage";

    // Request Attribute Keys
    public static final String ATTR_RESTAURANTS = "restaurants";
    public static final String ATTR_MENU_ITEMS  = "menuItems";
    public static final String ATTR_RESTAURANT  = "restaurant";
    public static final String ATTR_ORDERS      = "orders";
    public static final String ATTR_ORDER       = "order";
    public static final String ATTR_ERROR       = "error";

    // JSP Paths
    public static final String JSP_HOME          = "/jsp/home.jsp";
    public static final String JSP_RESTAURANT    = "/jsp/restaurant.jsp";
    public static final String JSP_MENU          = "/jsp/menu.jsp";
    public static final String JSP_CART          = "/jsp/cart.jsp";
    public static final String JSP_CHECKOUT      = "/jsp/checkout.jsp";
    public static final String JSP_LOGIN         = "/jsp/login.jsp";
    public static final String JSP_REGISTER      = "/jsp/register.jsp";
    public static final String JSP_ORDER_HISTORY = "/jsp/orderHistory.jsp";
    public static final String JSP_ORDER_CONFIRM = "/jsp/orderConfirm.jsp";
    public static final String JSP_ERROR         = "/jsp/error.jsp";

    // URL Patterns
    public static final String URL_HOME          = "/home";
    public static final String URL_RESTAURANT    = "/restaurant";
    public static final String URL_MENU          = "/menu";
    public static final String URL_CART          = "/cart";
    public static final String URL_CHECKOUT      = "/checkout";
    public static final String URL_LOGIN         = "/login";
    public static final String URL_LOGOUT        = "/logout";
    public static final String URL_REGISTER      = "/register";
    public static final String URL_ORDER         = "/order";
    public static final String URL_ORDER_HISTORY = "/orders";
    public static final String URL_SEARCH        = "/search";

    // Order Status
    public static final String ORDER_PENDING          = "PENDING";
    public static final String ORDER_PREPARING        = "PREPARING";
    public static final String ORDER_OUT_FOR_DELIVERY = "OUT_FOR_DELIVERY";
    public static final String ORDER_DELIVERED        = "DELIVERED";
    public static final String ORDER_CANCELLED        = "CANCELLED";

    // User Roles
    public static final String ROLE_CUSTOMER = "CUSTOMER";
    public static final String ROLE_ADMIN    = "ADMIN";

    // Business Rules
    public static final double TAX_RATE_PERCENT = 5.0;
    public static final int    MAX_CART_QUANTITY = 10;
    public static final String DEFAULT_CURRENCY  = "₹";

    // Brand Colors
    public static final String BRAND_PRIMARY   = "#C80238";
    public static final String BRAND_SECONDARY = "#FDA501";
    public static final String BRAND_ACCENT    = "#F92827";
    public static final String BRAND_CITRON    = "#C5C957";
    public static final String BRAND_BUFF      = "#D19B66";

    // Validation
    public static final int    PASSWORD_MIN_LENGTH = 6;
    public static final int    USERNAME_MAX_LENGTH = 100;
    public static final String EMAIL_REGEX         = "^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$";
    public static final String PHONE_REGEX         = "^[6-9]\\d{9}$";

    // Success Messages
    public static final String MSG_LOGIN_SUCCESS    = "Welcome back! You are now logged in.";
    public static final String MSG_LOGOUT_SUCCESS   = "You have been logged out successfully.";
    public static final String MSG_REGISTER_SUCCESS = "Account created successfully! Please login.";
    public static final String MSG_ORDER_PLACED     = "Your order has been placed successfully!";
    public static final String MSG_CART_ADDED       = "Item added to cart!";
    public static final String MSG_CART_REMOVED     = "Item removed from cart.";
    public static final String MSG_CART_UPDATED     = "Cart updated.";

    // Error Messages
    public static final String ERR_INVALID_CREDENTIALS = "Invalid email or password. Please try again.";
    public static final String ERR_EMAIL_EXISTS         = "An account with this email already exists.";
    public static final String ERR_SESSION_EXPIRED      = "Your session has expired. Please login again.";
    public static final String ERR_GENERIC              = "Something went wrong. Please try again.";
    public static final String ERR_CART_EMPTY           = "Your cart is empty. Add some items first!";
    public static final String ERR_ITEM_UNAVAILABLE     = "Sorry, this item is currently unavailable.";
    public static final String ERR_RESTAURANT_INACTIVE  = "This restaurant is currently closed.";
}

package com.tap.servlet;

import com.tap.dao.CartDAO;
import com.tap.dao.MenuDAO;
import com.tap.daoimpl.CartDAOImpl;
import com.tap.daoimpl.MenuDAOImpl;
import com.tap.model.CartItem;
import com.tap.model.User;
import com.tap.util.AppConstants;
import com.tap.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * CartServlet.java
 * Location: src/main/java/com/tap/servlet/CartServlet.java
 *
 * GET  /cart              → show cart page
 * GET  /cart?check=true   → JSON: return current cart restaurant info
 * POST /cart action=add   → add item (clears first if clearFirst=true)
 * POST /cart action=remove → remove one item
 * POST /cart action=update → update quantity
 * POST /cart action=clear  → clear entire cart
 *
 * KEY RULE: Cart can only hold items from ONE restaurant at a time.
 * If clearFirst=true in add request → clear old cart first, then add.
 */
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private MenuDAO menuDAO;

    @Override
    public void init() {
        cartDAO = new CartDAOImpl();
        menuDAO = new MenuDAOImpl();
    }

    // ─── GET ─────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null)
                ? (User) session.getAttribute(AppConstants.SESSION_USER)
                : null;

        if (user == null) {
            // For AJAX check requests, return JSON
            if ("true".equals(request.getParameter("check"))) {
                sendJson(response, "{\"cartRestaurantId\":0,\"cartCount\":0,\"cartRestaurantName\":\"\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + AppConstants.URL_LOGIN);
            return;
        }

        // ── AJAX: check what restaurant is currently in cart ──
        if ("true".equals(request.getParameter("check"))) {
            int    restId   = cartDAO.getCartRestaurantId(user.getUserId());
            String restName = cartDAO.getCartRestaurantName(user.getUserId());
            int    count    = cartDAO.getCartCount(user.getUserId());
            // Escape restaurant name for JSON safety
            restName = restName.replace("\"", "\\\"").replace("'", "\\'");
            sendJson(response,
                "{\"cartRestaurantId\":" + restId +
                ",\"cartCount\":"        + count  +
                ",\"cartRestaurantName\":\"" + restName + "\"}");
            return;
        }

        // ── Normal GET: show cart page ────────────────────────
        List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserId());

        double subtotal    = 0;
        for (CartItem item : cartItems) subtotal += item.getLineTotal();
        double deliveryFee = cartItems.isEmpty() ? 0 : 30.0;
        double tax         = Math.round(subtotal * AppConstants.TAX_RATE_PERCENT) / 100.0;
        double total       = subtotal + deliveryFee + tax;
        int    cartCount   = cartDAO.getCartCount(user.getUserId());

        session.setAttribute(AppConstants.SESSION_CART_COUNT, cartCount);

        request.setAttribute("cartItems",   cartItems);
        request.setAttribute("subtotal",    subtotal);
        request.setAttribute("deliveryFee", deliveryFee);
        request.setAttribute("tax",         tax);
        request.setAttribute("total",       total);
        request.setAttribute("cartCount",   cartCount);
        request.setAttribute("pageTitle",   "Your Cart — TapFood");

        request.getRequestDispatcher(AppConstants.JSP_CART)
               .forward(request, response);
    }

    // ─── POST ────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        HttpSession session = request.getSession(false);
        User user = (session != null)
                ? (User) session.getAttribute(AppConstants.SESSION_USER)
                : null;

        if (user == null) {
            sendJson(response,
                "{\"success\":false,\"message\":\"Please login to add items.\",\"cartCount\":0}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            sendJson(response,
                "{\"success\":false,\"message\":\"No action specified.\",\"cartCount\":0}");
            return;
        }

        try {
            switch (action.trim()) {

                // ════════════════════════════════════════════
                // ADD — with restaurant check
                // ════════════════════════════════════════════
                case "add": {
                    String menuIdStr    = request.getParameter("menuId");
                    String qtyStr       = request.getParameter("quantity");
                    String restIdStr    = request.getParameter("restaurantId");
                    String clearFirstStr= request.getParameter("clearFirst");

                    if (!ValidationUtil.isPositiveInt(menuIdStr)) {
                        sendJson(response,
                            "{\"success\":false,\"message\":\"Invalid menu item.\",\"cartCount\":0}");
                        return;
                    }

                    int menuId      = Integer.parseInt(menuIdStr.trim());
                    int quantity    = ValidationUtil.parsePositiveInt(qtyStr, 1);
                    int newRestId   = ValidationUtil.isPositiveInt(restIdStr)
                                        ? Integer.parseInt(restIdStr.trim()) : 0;
                    boolean clearFirst = "true".equals(clearFirstStr);

                    // Check item availability
                    if (!menuDAO.isItemAvailable(menuId)) {
                        sendJson(response,
                            "{\"success\":false,\"message\":\"" +
                            AppConstants.ERR_ITEM_UNAVAILABLE + "\",\"cartCount\":0}");
                        return;
                    }

                    int cartRestId = cartDAO.getCartRestaurantId(user.getUserId());

                    // ── Restaurant conflict detection ──────────
                    if (cartRestId != 0 && newRestId != 0 && cartRestId != newRestId) {
                        if (!clearFirst) {
                            // Tell frontend to show the popup
                            String oldName = cartDAO.getCartRestaurantName(user.getUserId())
                                                    .replace("\"","\\\"");
                            sendJson(response,
                                "{\"success\":false," +
                                "\"requiresClear\":true," +
                                "\"message\":\"Different restaurant\"," +
                                "\"cartRestaurantId\":" + cartRestId + "," +
                                "\"cartRestaurantName\":\"" + oldName + "\"," +
                                "\"cartCount\":0}");
                            return;
                        } else {
                            // User confirmed — clear old cart first
                            cartDAO.clearCart(user.getUserId());
                        }
                    }

                    boolean added    = cartDAO.addToCart(user.getUserId(), menuId, quantity);
                    int     newCount = cartDAO.getCartCount(user.getUserId());
                    session.setAttribute(AppConstants.SESSION_CART_COUNT, newCount);

                    if (added) {
                        sendJson(response,
                            "{\"success\":true,\"message\":\"" +
                            AppConstants.MSG_CART_ADDED + "\",\"cartCount\":" + newCount + "}");
                    } else {
                        sendJson(response,
                            "{\"success\":false,\"message\":\"" +
                            AppConstants.ERR_GENERIC + "\",\"cartCount\":" + newCount + "}");
                    }
                    break;
                }

                // ════════════════════════════════════════════
                // REMOVE
                // ════════════════════════════════════════════
                case "remove": {
                    String cartIdStr = request.getParameter("cartId");
                    if (!ValidationUtil.isPositiveInt(cartIdStr)) {
                        sendJson(response,
                            "{\"success\":false,\"message\":\"Invalid cart item.\",\"cartCount\":0}");
                        return;
                    }
                    int     cartId  = Integer.parseInt(cartIdStr.trim());
                    boolean removed = cartDAO.removeFromCart(cartId);
                    int     newCount= cartDAO.getCartCount(user.getUserId());
                    session.setAttribute(AppConstants.SESSION_CART_COUNT, newCount);

                    sendJson(response,
                        "{\"success\":" + removed +
                        ",\"message\":\"" + (removed ? AppConstants.MSG_CART_REMOVED : AppConstants.ERR_GENERIC) +
                        "\",\"cartCount\":" + newCount + "}");
                    break;
                }

                // ════════════════════════════════════════════
                // UPDATE QUANTITY
                // ════════════════════════════════════════════
                case "update": {
                    String cartIdStr = request.getParameter("cartId");
                    String qtyStr    = request.getParameter("quantity");

                    if (!ValidationUtil.isPositiveInt(cartIdStr)) {
                        sendJson(response,
                            "{\"success\":false,\"message\":\"Invalid cart item.\",\"cartCount\":0}");
                        return;
                    }

                    int cartId  = Integer.parseInt(cartIdStr.trim());
                    int qty     = ValidationUtil.parsePositiveInt(qtyStr, 1);

                    if (qty > AppConstants.MAX_CART_QUANTITY) {
                        sendJson(response,
                            "{\"success\":false,\"message\":\"Max " +
                            AppConstants.MAX_CART_QUANTITY + " items allowed.\",\"cartCount\":0}");
                        return;
                    }

                    boolean updated  = cartDAO.updateQuantity(cartId, qty);
                    int     newCount = cartDAO.getCartCount(user.getUserId());
                    session.setAttribute(AppConstants.SESSION_CART_COUNT, newCount);

                    sendJson(response,
                        "{\"success\":" + updated +
                        ",\"message\":\"" + (updated ? AppConstants.MSG_CART_UPDATED : AppConstants.ERR_GENERIC) +
                        "\",\"cartCount\":" + newCount + "}");
                    break;
                }

                // ════════════════════════════════════════════
                // CLEAR
                // ════════════════════════════════════════════
                case "clear": {
                    cartDAO.clearCart(user.getUserId());
                    session.setAttribute(AppConstants.SESSION_CART_COUNT, 0);
                    sendJson(response,
                        "{\"success\":true,\"message\":\"Cart cleared.\",\"cartCount\":0}");
                    break;
                }

                default:
                    sendJson(response,
                        "{\"success\":false,\"message\":\"Unknown action.\",\"cartCount\":0}");
            }

        } catch (Exception e) {
            sendJson(response,
                "{\"success\":false,\"message\":\"Server error: " +
                e.getMessage() + "\",\"cartCount\":0}");
        }
    }

    // ─── Helper ──────────────────────────────────────────────
    private void sendJson(HttpServletResponse response, String json)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
}

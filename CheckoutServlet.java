package com.tap.servlet;

import com.tap.dao.CartDAO;
import com.tap.dao.RestaurantDAO;
import com.tap.daoimpl.CartDAOImpl;
import com.tap.daoimpl.RestaurantDAOImpl;
import com.tap.model.CartItem;
import com.tap.model.Restaurant;
import com.tap.model.User;
import com.tap.util.AppConstants;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * CheckoutServlet.java
 * Location: src/main/java/com/tap/servlet/CheckoutServlet.java
 *
 * GET /checkout → show checkout page with cart summary + address form
 */
public class CheckoutServlet extends HttpServlet {

    private CartDAO       cartDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        cartDAO       = new CartDAOImpl();
        restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null)
                ? (User) session.getAttribute(AppConstants.SESSION_USER)
                : null;

        if (user == null) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_LOGIN);
            return;
        }

        // Load cart
        List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserId());

        if (cartItems.isEmpty()) {
            session.setAttribute(AppConstants.SESSION_MSG_ERROR,
                    AppConstants.ERR_CART_EMPTY);
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        // Calculate totals
        double subtotal = 0;
        for (CartItem item : cartItems) subtotal += item.getLineTotal();
        double deliveryFee = 30.0;
        double tax         = Math.round(subtotal * AppConstants.TAX_RATE_PERCENT) / 100.0;
        double total       = subtotal + deliveryFee + tax;

        // Load restaurant for this cart
        int        restaurantId = cartItems.get(0).getRestaurantId();
        Restaurant restaurant   = restaurantDAO.getRestaurantById(restaurantId);

        request.setAttribute("cartItems",    cartItems);
        request.setAttribute("restaurant",   restaurant);
        request.setAttribute("subtotal",     subtotal);
        request.setAttribute("deliveryFee",  deliveryFee);
        request.setAttribute("tax",          tax);
        request.setAttribute("total",        total);
        request.setAttribute("pageTitle",    "Checkout — TapFood");

        request.getRequestDispatcher(AppConstants.JSP_CHECKOUT)
               .forward(request, response);
    }
}

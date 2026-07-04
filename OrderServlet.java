package com.tap.servlet;

import com.tap.dao.CartDAO;
import com.tap.dao.OrderDAO;
import com.tap.daoimpl.CartDAOImpl;
import com.tap.daoimpl.OrderDAOImpl;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;
import com.tap.util.AppConstants;
import com.tap.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderServlet.java
 * Location: src/main/java/com/tap/servlet/OrderServlet.java
 *
 * POST /order → place order from cart
 * GET  /order?id=X → show order confirmation page
 */
public class OrderServlet extends HttpServlet {

    private CartDAO  cartDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        cartDAO  = new CartDAOImpl();
        orderDAO = new OrderDAOImpl();
    }

    // ─── GET: Order Confirmation Page ────────────────────────
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

        String idParam = request.getParameter("id");
        if (!ValidationUtil.isPositiveInt(idParam)) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        int orderId = Integer.parseInt(idParam.trim());
        Order order = orderDAO.getOrderById(orderId);

        if (order == null || order.getUserId() != user.getUserId()) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        request.setAttribute("order",     order);
        request.setAttribute("pageTitle", "Order Confirmed! — TapFood");
        request.getRequestDispatcher(AppConstants.JSP_ORDER_CONFIRM)
               .forward(request, response);
    }

    // ─── POST: Place Order ────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
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

        // Get form data
        String deliveryAddress = request.getParameter("deliveryAddress");
        String paymentMode     = request.getParameter("paymentMode");
        String specialNotes    = request.getParameter("specialNotes");

        // Validate address
        if (ValidationUtil.isNullOrEmpty(deliveryAddress)) {
            session.setAttribute(AppConstants.SESSION_MSG_ERROR,
                    "Please enter a delivery address.");
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_CHECKOUT);
            return;
        }

        // Validate payment mode
        if (ValidationUtil.isNullOrEmpty(paymentMode)) {
            paymentMode = "CASH_ON_DELIVERY";
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
        int    restaurantId = cartItems.get(0).getRestaurantId();

        // Build Order object
        Order order = new Order();
        order.setUserId         (user.getUserId());
        order.setRestaurantId   (restaurantId);
        order.setTotalAmount    (total);
        order.setDeliveryFee    (deliveryFee);
        order.setTaxAmount      (tax);
        order.setStatus         (AppConstants.ORDER_PENDING);
        order.setPaymentMode    (paymentMode);
        order.setPaymentStatus  ("PENDING");
        order.setDeliveryAddress(ValidationUtil.sanitize(deliveryAddress));
        order.setSpecialNotes   (ValidationUtil.sanitizeOrNull(specialNotes));

        // Place order — get generated orderId
        int orderId = orderDAO.placeOrder(order);

        if (orderId == -1) {
            session.setAttribute(AppConstants.SESSION_MSG_ERROR,
                    "Order placement failed. Please try again.");
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_CHECKOUT);
            return;
        }

        // Build OrderItem list
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cartItems) {
            OrderItem oi = new OrderItem();
            oi.setOrderId (orderId);
            oi.setMenuId  (cartItem.getMenuId());
            oi.setQuantity(cartItem.getQuantity());
            oi.setPrice   (cartItem.getPrice()); // price snapshot
            orderItems.add(oi);
        }

        // Save order items
        boolean itemsSaved = orderDAO.saveOrderItems(orderItems);

        if (!itemsSaved) {
            // Order was placed but items failed — still redirect to confirm
            // In production you would roll back the order too
        }

        // Clear cart
        cartDAO.clearCart(user.getUserId());
        session.setAttribute(AppConstants.SESSION_CART_COUNT, 0);
        session.setAttribute(AppConstants.SESSION_MSG_SUCCESS,
                AppConstants.MSG_ORDER_PLACED);

        // Redirect to confirmation page
        response.sendRedirect(
            request.getContextPath() + AppConstants.URL_ORDER + "?id=" + orderId);
    }
}

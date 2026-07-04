package com.tap.servlet;

import com.tap.dao.OrderDAO;
import com.tap.daoimpl.OrderDAOImpl;
import com.tap.model.Order;
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
 * OrderHistoryServlet.java
 * Location: src/main/java/com/tap/servlet/OrderHistoryServlet.java
 *
 * GET /orders → show all past orders for logged-in user
 */
public class OrderHistoryServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAOImpl();
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

        List<Order> orders = orderDAO.getOrdersByUser(user.getUserId());

        request.setAttribute(AppConstants.ATTR_ORDERS, orders);
        request.setAttribute("pageTitle", "My Orders — TapFood");

        request.getRequestDispatcher(AppConstants.JSP_ORDER_HISTORY)
               .forward(request, response);
    }
}

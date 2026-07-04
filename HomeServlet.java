package com.tap.servlet;

import com.tap.dao.RestaurantDAO;
import com.tap.daoimpl.RestaurantDAOImpl;
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
 * HomeServlet.java
 * Location: src/main/java/com/tap/servlet/HomeServlet.java
 *
 * Handles GET /home
 * Supports filter param: ?filter=all|top-rated|fast-delivery|veg
 */
public class HomeServlet extends HttpServlet {

    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // ── Determine active filter ───────────────────────────
        String filter = request.getParameter("filter");
        if (filter == null || filter.trim().isEmpty()) {
            filter = "all";
        }

        // ── Load restaurants based on filter ─────────────────
        List<Restaurant> restaurants;
        switch (filter) {
            case "top-rated":
                restaurants = restaurantDAO.getTopRatedRestaurants();
                break;
            case "fast-delivery":
                restaurants = restaurantDAO.getRestaurantsByDeliveryTime();
                break;
            case "veg":
                restaurants = restaurantDAO.getVegRestaurants();
                break;
            default:
                filter = "all";
                restaurants = restaurantDAO.getAllActiveRestaurants();
                break;
        }

        // ── Cart count for navbar badge ───────────────────────
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute(AppConstants.SESSION_USER);
            if (user != null && session.getAttribute(AppConstants.SESSION_CART_COUNT) == null) {
                // Will be set properly when cart is accessed
                session.setAttribute(AppConstants.SESSION_CART_COUNT, 0);
            }
        }

        // ── Set attributes and forward ────────────────────────
        request.setAttribute(AppConstants.ATTR_RESTAURANTS, restaurants);
        request.setAttribute("activeFilter", filter);
        request.setAttribute("restaurantCount", restaurants.size());
        request.setAttribute("pageTitle", "TapFood — Order Food Online");

        request.getRequestDispatcher(AppConstants.JSP_HOME)
               .forward(request, response);
    }
}

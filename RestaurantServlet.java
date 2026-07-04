package com.tap.servlet;

import com.tap.dao.MenuDAO;
import com.tap.dao.RestaurantDAO;
import com.tap.daoimpl.MenuDAOImpl;
import com.tap.daoimpl.RestaurantDAOImpl;
import com.tap.model.MenuItem;
import com.tap.model.Restaurant;
import com.tap.util.AppConstants;
import com.tap.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * RestaurantServlet.java
 * Location: src/main/java/com/tap/servlet/RestaurantServlet.java
 *
 * Handles GET /restaurant?id=1
 * Loads restaurant details + full menu grouped by category.
 * Stores restaurant in session for cart cross-reference.
 */
public class RestaurantServlet extends HttpServlet {

    private RestaurantDAO restaurantDAO;
    private MenuDAO       menuDAO;

    @Override
    public void init() {
        restaurantDAO = new RestaurantDAOImpl();
        menuDAO       = new MenuDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // Validate restaurant ID
        if (!ValidationUtil.isPositiveInt(idParam)) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        int restaurantId = Integer.parseInt(idParam.trim());

        // Load restaurant
        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);

        if (restaurant == null || !restaurant.isActive()) {
            request.getSession().setAttribute(
                AppConstants.SESSION_MSG_ERROR,
                AppConstants.ERR_RESTAURANT_INACTIVE);
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        // Load full menu + categories
        List<MenuItem> menuItems  = menuDAO.getMenuByRestaurant(restaurantId);
        List<String>   categories = menuDAO.getCategoriesByRestaurant(restaurantId);
        List<MenuItem> bestsellers = menuDAO.getBestsellers(restaurantId);

        // Store restaurant in session (cart module uses this to enforce
        // single-restaurant cart rule)
        HttpSession session = request.getSession(true);
        session.setAttribute(AppConstants.SESSION_RESTAURANT, restaurant);

        // Forward to JSP
        request.setAttribute(AppConstants.ATTR_RESTAURANT, restaurant);
        request.setAttribute(AppConstants.ATTR_MENU_ITEMS, menuItems);
        request.setAttribute("categories",  categories);
        request.setAttribute("bestsellers", bestsellers);
        request.setAttribute("pageTitle",
            restaurant.getName() + " — TapFood");

        request.getRequestDispatcher(AppConstants.JSP_RESTAURANT)
               .forward(request, response);
    }
}

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

import java.io.IOException;
import java.util.List;

/**
 * MenuServlet.java
 * Location: src/main/java/com/tap/servlet/MenuServlet.java
 *
 * Handles GET /menu?restaurantId=1
 * Optional: ?category=Starters  (filters by category)
 * Optional: ?veg=true           (shows only veg items)
 *
 * Forwards to menu.jsp which is the full order page.
 */
public class MenuServlet extends HttpServlet {

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

        String idParam = request.getParameter("restaurantId");

        if (!ValidationUtil.isPositiveInt(idParam)) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        int restaurantId = Integer.parseInt(idParam.trim());

        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);

        if (restaurant == null || !restaurant.isActive()) {
            request.getSession().setAttribute(
                AppConstants.SESSION_MSG_ERROR,
                AppConstants.ERR_RESTAURANT_INACTIVE);
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        // Optional filters
        String  categoryFilter = request.getParameter("category");
        boolean vegOnly        = "true".equals(request.getParameter("veg"));

        List<MenuItem> menuItems;

        if (vegOnly) {
            menuItems = menuDAO.getVegItems(restaurantId);
        } else if (ValidationUtil.isNotNullOrEmpty(categoryFilter)) {
            menuItems = menuDAO.getMenuByCategory(restaurantId, categoryFilter);
        } else {
            menuItems = menuDAO.getMenuByRestaurant(restaurantId);
        }

        List<String>   categories  = menuDAO.getCategoriesByRestaurant(restaurantId);
        List<MenuItem> bestsellers = menuDAO.getBestsellers(restaurantId);

        request.setAttribute(AppConstants.ATTR_RESTAURANT,  restaurant);
        request.setAttribute(AppConstants.ATTR_MENU_ITEMS,  menuItems);
        request.setAttribute("categories",      categories);
        request.setAttribute("bestsellers",     bestsellers);
        request.setAttribute("activeCategory",  categoryFilter);
        request.setAttribute("vegOnly",         vegOnly);
        request.setAttribute("pageTitle",
            "Menu — " + restaurant.getName() + " | TapFood");

        request.getRequestDispatcher(AppConstants.JSP_MENU)
               .forward(request, response);
    }
}

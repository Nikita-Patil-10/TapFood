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
import java.util.ArrayList;
import java.util.List;

/**
 * SearchServlet.java
 * Location: src/main/java/com/tap/servlet/SearchServlet.java
 *
 * FIXED:
 * 1. Searches BOTH restaurants AND menu items (food names)
 * 2. Returns matching restaurants + restaurants that have matching menu items
 * 3. Forwards to search.jsp (dedicated page) instead of home.jsp
 */
public class SearchServlet extends HttpServlet {

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

        String keyword = request.getParameter("q");

        // Empty search → go back home
        if (ValidationUtil.isNullOrEmpty(keyword)) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        keyword = keyword.trim();

        // 1. Search restaurants by name / cuisine / address
        List<Restaurant> restaurantResults =
                restaurantDAO.searchRestaurants(keyword);

        // 2. Search menu items by name — collect their restaurants
        List<MenuItem>   menuResults       =
                menuDAO.searchMenuItems(keyword);

        // 3. Merge — add restaurants from menu search that aren't already listed
        List<Integer> alreadyAdded = new ArrayList<>();
        for (Restaurant r : restaurantResults) {
            alreadyAdded.add(r.getRestaurantId());
        }

        for (MenuItem item : menuResults) {
            if (!alreadyAdded.contains(item.getRestaurantId())) {
                Restaurant r = restaurantDAO.getRestaurantById(
                        item.getRestaurantId());
                if (r != null) {
                    restaurantResults.add(r);
                    alreadyAdded.add(r.getRestaurantId());
                }
            }
        }

        // 4. Build result message
        String searchMessage;
        if (restaurantResults.isEmpty()) {
            searchMessage = "No results found for \"" + keyword +
                    "\". Try searching for biryani, pizza, burger...";
        } else {
            searchMessage = restaurantResults.size() + " restaurant" +
                    (restaurantResults.size() > 1 ? "s" : "") +
                    " found for \"" + keyword + "\"";
        }

        request.setAttribute(AppConstants.ATTR_RESTAURANTS, restaurantResults);
        request.setAttribute("menuResults",    menuResults);
        request.setAttribute("searchKeyword",  keyword);
        request.setAttribute("searchMessage",  searchMessage);
        request.setAttribute("pageTitle",
                "\"" + keyword + "\" — Search Results | TapFood");

        request.getRequestDispatcher("/jsp/search.jsp")
               .forward(request, response);
    }
}

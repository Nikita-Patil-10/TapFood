package com.tap.dao;

import com.tap.model.MenuItem;
import java.util.List;

/**
 * MenuDAO.java
 * Location: src/main/java/com/tap/dao/MenuDAO.java
 */
public interface MenuDAO {

    /** Get all available menu items for a restaurant */
    List<MenuItem> getMenuByRestaurant(int restaurantId);

    /** Get menu items by category */
    List<MenuItem> getMenuByCategory(int restaurantId, String category);

    /** Get a single menu item by ID */
    MenuItem getMenuItemById(int menuId);

    /** Get bestseller items for a restaurant */
    List<MenuItem> getBestsellers(int restaurantId);

    /** Get only veg items for a restaurant */
    List<MenuItem> getVegItems(int restaurantId);

    /** Get all distinct categories for a restaurant */
    List<String> getCategoriesByRestaurant(int restaurantId);

    /** Check if a menu item is available */
    boolean isItemAvailable(int menuId);

    /** Search menu items by name or description — used by SearchServlet */
    List<MenuItem> searchMenuItems(String keyword);
}

package com.tap.dao;

import com.tap.model.MenuItem;
import com.tap.model.Order;
import com.tap.model.Restaurant;
import com.tap.model.User;

import java.util.List;

/**
 * AdminDAO.java
 * Location: src/main/java/com/tap/dao/AdminDAO.java
 *
 * All admin-specific database operations:
 * Restaurant CRUD, Menu CRUD, Order management, User management.
 */
public interface AdminDAO {

    // ── Dashboard stats ───────────────────────────────────────
    int    getTotalRestaurants();
    int    getTotalUsers();
    int    getTotalOrders();
    double getTotalRevenue();
    int    getTodayOrders();
    List<Order> getRecentOrders(int limit);

    // ── Restaurant CRUD ───────────────────────────────────────
    List<Restaurant> getAllRestaurants();
    Restaurant       getRestaurantById(int restaurantId);
    boolean          addRestaurant(Restaurant restaurant);
    boolean          updateRestaurant(Restaurant restaurant);
    boolean          toggleRestaurantStatus(int restaurantId, boolean isActive);
    boolean          deleteRestaurant(int restaurantId);

    // ── Menu CRUD ─────────────────────────────────────────────
    List<MenuItem> getAllMenuItems();
    List<MenuItem> getMenuItemsByRestaurant(int restaurantId);
    MenuItem       getMenuItemById(int menuId);
    boolean        addMenuItem(MenuItem item);
    boolean        updateMenuItem(MenuItem item);
    boolean        toggleMenuItemAvailability(int menuId, boolean isAvailable);
    boolean        deleteMenuItem(int menuId);

    // ── Order management ──────────────────────────────────────
    List<Order> getAllOrders();
    List<Order> getOrdersByStatus(String status);
    Order       getOrderById(int orderId);
    boolean     updateOrderStatus(int orderId, String status);

    // ── User management ───────────────────────────────────────
    List<User> getAllUsers();
    User       getUserById(int userId);
    boolean    toggleUserStatus(int userId, boolean isActive);
}

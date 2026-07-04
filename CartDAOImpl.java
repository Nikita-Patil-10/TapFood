package com.tap.daoimpl;

import com.tap.dao.CartDAO;
import com.tap.model.CartItem;
import com.tap.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * CartDAOImpl.java
 * Location: src/main/java/com/tap/daoimpl/CartDAOImpl.java
 *
 * FIXED: Added getCartRestaurantId() and getCartRestaurantName()
 * for single-restaurant cart enforcement.
 */
public class CartDAOImpl implements CartDAO {

    private static final Logger LOGGER =
            Logger.getLogger(CartDAOImpl.class.getName());

    private static final String SQL_GET_CART =
        "SELECT c.cartId, c.userId, c.menuId, c.quantity, " +
        "       m.name, m.price, m.image, m.isVeg, " +
        "       m.restaurantId, r.name AS restaurantName " +
        "FROM cart c " +
        "INNER JOIN menu m ON c.menuId = m.menuId " +
        "INNER JOIN restaurant r ON m.restaurantId = r.restaurantId " +
        "WHERE c.userId = ? " +
        "ORDER BY c.addedAt DESC";

    private static final String SQL_ITEM_IN_CART =
        "SELECT cartId FROM cart WHERE userId = ? AND menuId = ?";

    private static final String SQL_ADD_TO_CART =
        "INSERT INTO cart (userId, menuId, quantity) VALUES (?, ?, ?)";

    private static final String SQL_INCREMENT_QTY =
        "UPDATE cart SET quantity = quantity + ? WHERE userId = ? AND menuId = ?";

    private static final String SQL_REMOVE_ITEM =
        "DELETE FROM cart WHERE cartId = ?";

    private static final String SQL_UPDATE_QTY =
        "UPDATE cart SET quantity = ? WHERE cartId = ?";

    private static final String SQL_CLEAR_CART =
        "DELETE FROM cart WHERE userId = ?";

    private static final String SQL_CART_COUNT =
        "SELECT COALESCE(SUM(quantity), 0) FROM cart WHERE userId = ?";

    private static final String SQL_SUBTOTAL =
        "SELECT COALESCE(SUM(c.quantity * m.price), 0) " +
        "FROM cart c INNER JOIN menu m ON c.menuId = m.menuId " +
        "WHERE c.userId = ?";

    private static final String SQL_GET_CART_ID =
        "SELECT cartId FROM cart WHERE userId = ? AND menuId = ?";

    // NEW: get restaurant of items currently in cart
    private static final String SQL_GET_CART_RESTAURANT_ID =
        "SELECT m.restaurantId FROM cart c " +
        "INNER JOIN menu m ON c.menuId = m.menuId " +
        "WHERE c.userId = ? LIMIT 1";

    private static final String SQL_GET_CART_RESTAURANT_NAME =
        "SELECT r.name FROM cart c " +
        "INNER JOIN menu m ON c.menuId = m.menuId " +
        "INNER JOIN restaurant r ON m.restaurantId = r.restaurantId " +
        "WHERE c.userId = ? LIMIT 1";

    // ─────────────────────────────────────────────────────────
    // GET CART BY USER
    // ─────────────────────────────────────────────────────────
    @Override
    public List<CartItem> getCartByUser(int userId) {
        List<CartItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_CART);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartId        (rs.getInt    ("cartId"));
                item.setUserId        (rs.getInt    ("userId"));
                item.setMenuId        (rs.getInt    ("menuId"));
                item.setQuantity      (rs.getInt    ("quantity"));
                item.setName          (rs.getString ("name"));
                item.setPrice         (rs.getDouble ("price"));
                item.setImage         (rs.getString ("image"));
                item.setVeg           (rs.getBoolean("isVeg"));
                item.setRestaurantId  (rs.getInt    ("restaurantId"));
                item.setRestaurantName(rs.getString ("restaurantName"));
                list.add(item);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] getCartByUser failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // ADD TO CART
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean addToCart(int userId, int menuId, int quantity) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            if (isItemInCart(userId, menuId)) {
                PreparedStatement ps = conn.prepareStatement(SQL_INCREMENT_QTY);
                ps.setInt(1, quantity);
                ps.setInt(2, userId);
                ps.setInt(3, menuId);
                return ps.executeUpdate() > 0;
            } else {
                PreparedStatement ps = conn.prepareStatement(SQL_ADD_TO_CART);
                ps.setInt(1, userId);
                ps.setInt(2, menuId);
                ps.setInt(3, quantity);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] addToCart failed", e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // REMOVE ITEM
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean removeFromCart(int cartId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_REMOVE_ITEM);
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] removeFromCart failed", e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // UPDATE QUANTITY
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean updateQuantity(int cartId, int quantity) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_QTY);
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] updateQuantity failed", e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // CLEAR CART
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean clearCart(int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_CLEAR_CART);
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] clearCart failed", e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // GET CART COUNT
    // ─────────────────────────────────────────────────────────
    @Override
    public int getCartCount(int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_CART_COUNT);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] getCartCount failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    // ─────────────────────────────────────────────────────────
    // GET CART SUBTOTAL
    // ─────────────────────────────────────────────────────────
    @Override
    public double getCartSubtotal(int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_SUBTOTAL);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] getCartSubtotal failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0.0;
    }

    // ─────────────────────────────────────────────────────────
    // IS ITEM IN CART
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean isItemInCart(int userId, int menuId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_ITEM_IN_CART);
            ps.setInt(1, userId);
            ps.setInt(2, menuId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] isItemInCart failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    // ─────────────────────────────────────────────────────────
    // GET CART ID
    // ─────────────────────────────────────────────────────────
    @Override
    public int getCartId(int userId, int menuId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_CART_ID);
            ps.setInt(1, userId);
            ps.setInt(2, menuId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("cartId");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] getCartId failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return -1;
    }

    // ─────────────────────────────────────────────────────────
    // GET CART RESTAURANT ID  ← NEW
    // Returns 0 if cart is empty
    // ─────────────────────────────────────────────────────────
    @Override
    public int getCartRestaurantId(int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_CART_RESTAURANT_ID);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("restaurantId");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] getCartRestaurantId failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0; // 0 = cart is empty
    }

    // ─────────────────────────────────────────────────────────
    // GET CART RESTAURANT NAME  ← NEW
    // ─────────────────────────────────────────────────────────
    @Override
    public String getCartRestaurantName(int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_CART_RESTAURANT_NAME);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("name");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[CartDAO] getCartRestaurantName failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return "";
    }
}

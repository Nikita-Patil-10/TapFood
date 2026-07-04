package com.tap.daoimpl;

import com.tap.dao.OrderDAO;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * OrderDAOImpl.java
 * Location: src/main/java/com/tap/daoimpl/OrderDAOImpl.java
 *
 * Uses JDBC transactions for placeOrder + saveOrderItems
 * to guarantee atomicity — either both succeed or both roll back.
 */
public class OrderDAOImpl implements OrderDAO {

    private static final Logger LOGGER =
            Logger.getLogger(OrderDAOImpl.class.getName());

    private static final String SQL_PLACE_ORDER =
        "INSERT INTO orders (userId, restaurantId, totalAmount, deliveryFee, taxAmount, " +
        "status, paymentMode, paymentStatus, deliveryAddress, specialNotes) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_SAVE_ORDER_ITEMS =
        "INSERT INTO order_items (orderId, menuId, quantity, price) VALUES (?, ?, ?, ?)";

    private static final String SQL_GET_ORDER_BY_ID =
        "SELECT o.*, r.name AS restaurantName, r.imagePath AS restaurantImage " +
        "FROM orders o " +
        "INNER JOIN restaurant r ON o.restaurantId = r.restaurantId " +
        "WHERE o.orderId = ?";

    private static final String SQL_GET_ORDERS_BY_USER =
        "SELECT o.*, r.name AS restaurantName, r.imagePath AS restaurantImage " +
        "FROM orders o " +
        "INNER JOIN restaurant r ON o.restaurantId = r.restaurantId " +
        "WHERE o.userId = ? " +
        "ORDER BY o.orderDate DESC";

    private static final String SQL_GET_ORDER_ITEMS =
        "SELECT oi.*, m.name, m.image, m.isVeg " +
        "FROM order_items oi " +
        "INNER JOIN menu m ON oi.menuId = m.menuId " +
        "WHERE oi.orderId = ?";

    private static final String SQL_UPDATE_STATUS =
        "UPDATE orders SET status = ? WHERE orderId = ?";

    // ─────────────────────────────────────────────────────────
    // PLACE ORDER
    // Returns the generated orderId or -1 if failed
    // ─────────────────────────────────────────────────────────
    @Override
    public int placeOrder(Order order) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                    SQL_PLACE_ORDER, Statement.RETURN_GENERATED_KEYS);

            ps.setInt   (1,  order.getUserId());
            ps.setInt   (2,  order.getRestaurantId());
            ps.setDouble(3,  order.getTotalAmount());
            ps.setDouble(4,  order.getDeliveryFee());
            ps.setDouble(5,  order.getTaxAmount());
            ps.setString(6,  order.getStatus() != null ? order.getStatus() : "PENDING");
            ps.setString(7,  order.getPaymentMode() != null ? order.getPaymentMode() : "CASH_ON_DELIVERY");
            ps.setString(8,  order.getPaymentStatus() != null ? order.getPaymentStatus() : "PENDING");
            ps.setString(9,  order.getDeliveryAddress());
            ps.setString(10, order.getSpecialNotes());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1); // Return the generated orderId
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[OrderDAO] placeOrder failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return -1;
    }

    // ─────────────────────────────────────────────────────────
    // SAVE ORDER ITEMS
    // Uses batch insert for efficiency
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean saveOrderItems(List<OrderItem> items) {
        if (items == null || items.isEmpty()) return false;

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            PreparedStatement ps = conn.prepareStatement(SQL_SAVE_ORDER_ITEMS);

            for (OrderItem item : items) {
                ps.setInt   (1, item.getOrderId());
                ps.setInt   (2, item.getMenuId());
                ps.setInt   (3, item.getQuantity());
                ps.setDouble(4, item.getPrice());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            conn.commit(); // Commit transaction

            // Verify all rows inserted
            for (int r : results) {
                if (r <= 0) {
                    LOGGER.warning("[OrderDAO] One or more order items may not have saved.");
                }
            }
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[OrderDAO] saveOrderItems failed — rolling back", e);
            DBConnection.rollback(conn);
            return false;
        } finally {
            // Restore auto-commit before returning to pool
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            }
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // GET ORDER BY ID
    // ─────────────────────────────────────────────────────────
    @Override
    public Order getOrderById(int orderId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_ORDER_BY_ID);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapRow(rs);
                // Also load order items
                order.setOrderItems(getOrderItems(orderId));
                return order;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[OrderDAO] getOrderById failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // ─────────────────────────────────────────────────────────
    // GET ORDERS BY USER
    // ─────────────────────────────────────────────────────────
    @Override
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_ORDERS_BY_USER);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[OrderDAO] getOrdersByUser failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // GET ORDER ITEMS
    // ─────────────────────────────────────────────────────────
    @Override
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_ORDER_ITEMS);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt    ("orderItemId"));
                item.setOrderId    (rs.getInt    ("orderId"));
                item.setMenuId     (rs.getInt    ("menuId"));
                item.setQuantity   (rs.getInt    ("quantity"));
                item.setPrice      (rs.getDouble ("price"));
                item.setName       (rs.getString ("name"));
                item.setImage      (rs.getString ("image"));
                item.setVeg        (rs.getBoolean("isVeg"));
                list.add(item);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[OrderDAO] getOrderItems failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // UPDATE ORDER STATUS
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_STATUS);
            ps.setString(1, status);
            ps.setInt   (2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[OrderDAO] updateOrderStatus failed", e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // PRIVATE HELPER — Map ResultSet row → Order object
    // ─────────────────────────────────────────────────────────
    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId        (rs.getInt    ("orderId"));
        o.setUserId         (rs.getInt    ("userId"));
        o.setRestaurantId   (rs.getInt    ("restaurantId"));
        o.setTotalAmount    (rs.getDouble ("totalAmount"));
        o.setDeliveryFee    (rs.getDouble ("deliveryFee"));
        o.setTaxAmount      (rs.getDouble ("taxAmount"));
        o.setStatus         (rs.getString ("status"));
        o.setPaymentMode    (rs.getString ("paymentMode"));
        o.setPaymentStatus  (rs.getString ("paymentStatus"));
        o.setDeliveryAddress(rs.getString ("deliveryAddress"));
        o.setSpecialNotes   (rs.getString ("specialNotes"));
        o.setRestaurantName (rs.getString ("restaurantName"));
        o.setRestaurantImage(rs.getString ("restaurantImage"));

        Timestamp orderDate = rs.getTimestamp("orderDate");
        if (orderDate != null) o.setOrderDate(orderDate.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        if (updatedAt != null) o.setUpdatedAt(updatedAt.toLocalDateTime());

        return o;
    }
}

package com.tap.daoimpl;

import com.tap.dao.AdminDAO;
import com.tap.model.MenuItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;
import com.tap.model.User;
import com.tap.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AdminDAOImpl.java
 * Location: src/main/java/com/tap/daoimpl/AdminDAOImpl.java
 */
public class AdminDAOImpl implements AdminDAO {

    private static final Logger LOGGER =
            Logger.getLogger(AdminDAOImpl.class.getName());

    // ══════════════════════════════════════════════════════════
    // DASHBOARD STATS
    // ══════════════════════════════════════════════════════════

    @Override
    public int getTotalRestaurants() {
        return countQuery("SELECT COUNT(*) FROM restaurant");
    }

    @Override
    public int getTotalUsers() {
        return countQuery("SELECT COUNT(*) FROM user WHERE role='CUSTOMER'");
    }

    @Override
    public int getTotalOrders() {
        return countQuery("SELECT COUNT(*) FROM orders");
    }

    @Override
    public double getTotalRevenue() {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COALESCE(SUM(totalAmount),0) FROM orders WHERE status='DELIVERED'");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getTotalRevenue failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return 0;
    }

    @Override
    public int getTodayOrders() {
        return countQuery(
            "SELECT COUNT(*) FROM orders WHERE DATE(orderDate) = CURDATE()");
    }

    @Override
    public List<Order> getRecentOrders(int limit) {
        List<Order> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT o.*, r.name AS restaurantName, u.username " +
                "FROM orders o " +
                "JOIN restaurant r ON o.restaurantId = r.restaurantId " +
                "JOIN user u ON o.userId = u.userId " +
                "ORDER BY o.orderDate DESC LIMIT ?");
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setRestaurantName(rs.getString("restaurantName"));
                // store username in specialNotes field temporarily for display
                o.setSpecialNotes(rs.getString("username"));
                list.add(o);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getRecentOrders failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return list;
    }

    // ══════════════════════════════════════════════════════════
    // RESTAURANT CRUD
    // ══════════════════════════════════════════════════════════

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT *, " +
                "(SELECT COUNT(*) FROM menu m WHERE m.restaurantId = r.restaurantId) AS menuCount " +
                "FROM restaurant r ORDER BY r.restaurantId DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Restaurant r = mapRestaurant(rs);
                list.add(r);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getAllRestaurants failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return list;
    }

    @Override
    public Restaurant getRestaurantById(int id) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM restaurant WHERE restaurantId = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRestaurant(rs);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getRestaurantById failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return null;
    }

    @Override
    public boolean addRestaurant(Restaurant r) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO restaurant (name, address, city, phone, ratings, imagePath, " +
                "deliveryTime, deliveryFee, minOrderAmount, description, cuisineType, " +
                "colorPrimary, colorSecondary, offerText, isActive) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,1)");
            ps.setString(1,  r.getName());
            ps.setString(2,  r.getAddress());
            ps.setString(3,  r.getCity() != null ? r.getCity() : "Bengaluru");
            ps.setString(4,  r.getPhone());
            ps.setDouble(5,  r.getRatings());
            ps.setString(6,  r.getImagePath() != null ? r.getImagePath() : "default-restaurant.jpg");
            ps.setInt   (7,  r.getDeliveryTime());
            ps.setDouble(8,  r.getDeliveryFee());
            ps.setDouble(9,  r.getMinOrderAmount());
            ps.setString(10, r.getDescription());
            ps.setString(11, r.getCuisineType());
            ps.setString(12, r.getColorPrimary() != null ? r.getColorPrimary() : "#C80238");
            ps.setString(13, r.getColorSecondary() != null ? r.getColorSecondary() : "#FDA501");
            ps.setString(14, r.getOfferText());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] addRestaurant failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    @Override
    public boolean updateRestaurant(Restaurant r) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE restaurant SET name=?, address=?, city=?, phone=?, ratings=?, " +
                "imagePath=?, deliveryTime=?, deliveryFee=?, minOrderAmount=?, " +
                "description=?, cuisineType=?, colorPrimary=?, colorSecondary=?, offerText=? " +
                "WHERE restaurantId=?");
            ps.setString(1,  r.getName());
            ps.setString(2,  r.getAddress());
            ps.setString(3,  r.getCity());
            ps.setString(4,  r.getPhone());
            ps.setDouble(5,  r.getRatings());
            ps.setString(6,  r.getImagePath());
            ps.setInt   (7,  r.getDeliveryTime());
            ps.setDouble(8,  r.getDeliveryFee());
            ps.setDouble(9,  r.getMinOrderAmount());
            ps.setString(10, r.getDescription());
            ps.setString(11, r.getCuisineType());
            ps.setString(12, r.getColorPrimary());
            ps.setString(13, r.getColorSecondary());
            ps.setString(14, r.getOfferText());
            ps.setInt   (15, r.getRestaurantId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] updateRestaurant failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    @Override
    public boolean toggleRestaurantStatus(int restaurantId, boolean isActive) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE restaurant SET isActive=? WHERE restaurantId=?");
            ps.setBoolean(1, isActive);
            ps.setInt    (2, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] toggleRestaurantStatus failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM restaurant WHERE restaurantId=?");
            ps.setInt(1, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] deleteRestaurant failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    // ══════════════════════════════════════════════════════════
    // MENU CRUD
    // ══════════════════════════════════════════════════════════

    @Override
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT m.*, r.name AS restaurantName FROM menu m " +
                "JOIN restaurant r ON m.restaurantId = r.restaurantId " +
                "ORDER BY m.restaurantId, m.category, m.name");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapMenuItem(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getAllMenuItems failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return list;
    }

    @Override
    public List<MenuItem> getMenuItemsByRestaurant(int restaurantId) {
        List<MenuItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT m.*, r.name AS restaurantName FROM menu m " +
                "JOIN restaurant r ON m.restaurantId = r.restaurantId " +
                "WHERE m.restaurantId=? ORDER BY m.category, m.name");
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapMenuItem(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getMenuItemsByRestaurant failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return list;
    }

    @Override
    public MenuItem getMenuItemById(int menuId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT m.*, r.name AS restaurantName FROM menu m " +
                "JOIN restaurant r ON m.restaurantId = r.restaurantId " +
                "WHERE m.menuId=?");
            ps.setInt(1, menuId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapMenuItem(rs);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getMenuItemById failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return null;
    }

    @Override
    public boolean addMenuItem(MenuItem item) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO menu (restaurantId,name,price,description,image," +
                "isVeg,isBestseller,isAvailable,category,spiceLevel) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?)");
            ps.setInt    (1,  item.getRestaurantId());
            ps.setString (2,  item.getName());
            ps.setDouble (3,  item.getPrice());
            ps.setString (4,  item.getDescription());
            ps.setString (5,  item.getImage() != null ? item.getImage() : "default-food.jpg");
            ps.setBoolean(6,  item.isVeg());
            ps.setBoolean(7,  item.isBestseller());
            ps.setBoolean(8,  item.isAvailable());
            ps.setString (9,  item.getCategory());
            ps.setString (10, item.getSpiceLevel() != null ? item.getSpiceLevel() : "MEDIUM");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] addMenuItem failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    @Override
    public boolean updateMenuItem(MenuItem item) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE menu SET restaurantId=?,name=?,price=?,description=?,image=?," +
                "isVeg=?,isBestseller=?,isAvailable=?,category=?,spiceLevel=? " +
                "WHERE menuId=?");
            ps.setInt    (1,  item.getRestaurantId());
            ps.setString (2,  item.getName());
            ps.setDouble (3,  item.getPrice());
            ps.setString (4,  item.getDescription());
            ps.setString (5,  item.getImage());
            ps.setBoolean(6,  item.isVeg());
            ps.setBoolean(7,  item.isBestseller());
            ps.setBoolean(8,  item.isAvailable());
            ps.setString (9,  item.getCategory());
            ps.setString (10, item.getSpiceLevel());
            ps.setInt    (11, item.getMenuId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] updateMenuItem failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    @Override
    public boolean toggleMenuItemAvailability(int menuId, boolean isAvailable) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE menu SET isAvailable=? WHERE menuId=?");
            ps.setBoolean(1, isAvailable);
            ps.setInt    (2, menuId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] toggleMenuItemAvailability failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    @Override
    public boolean deleteMenuItem(int menuId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM menu WHERE menuId=?");
            ps.setInt(1, menuId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] deleteMenuItem failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    // ══════════════════════════════════════════════════════════
    // ORDER MANAGEMENT
    // ══════════════════════════════════════════════════════════

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT o.*, r.name AS restaurantName, u.username AS userName " +
                "FROM orders o " +
                "JOIN restaurant r ON o.restaurantId = r.restaurantId " +
                "JOIN user u ON o.userId = u.userId " +
                "ORDER BY o.orderDate DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setRestaurantName(rs.getString("restaurantName"));
                o.setSpecialNotes(rs.getString("userName"));
                list.add(o);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getAllOrders failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return list;
    }

    @Override
    public List<Order> getOrdersByStatus(String status) {
        List<Order> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT o.*, r.name AS restaurantName, u.username AS userName " +
                "FROM orders o " +
                "JOIN restaurant r ON o.restaurantId = r.restaurantId " +
                "JOIN user u ON o.userId = u.userId " +
                "WHERE o.status=? ORDER BY o.orderDate DESC");
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setRestaurantName(rs.getString("restaurantName"));
                o.setSpecialNotes(rs.getString("userName"));
                list.add(o);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getOrdersByStatus failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return list;
    }

    @Override
    public Order getOrderById(int orderId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT o.*, r.name AS restaurantName, u.username AS userName " +
                "FROM orders o " +
                "JOIN restaurant r ON o.restaurantId = r.restaurantId " +
                "JOIN user u ON o.userId = u.userId " +
                "WHERE o.orderId=?");
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order o = mapOrder(rs);
                o.setRestaurantName(rs.getString("restaurantName"));
                o.setSpecialNotes(rs.getString("userName"));
                // load items
                o.setOrderItems(getOrderItemsForOrder(orderId, conn));
                return o;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getOrderById failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return null;
    }

    private List<OrderItem> getOrderItemsForOrder(int orderId, Connection conn) {
        List<OrderItem> items = new ArrayList<>();
        try {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT oi.*, m.name, m.image, m.isVeg FROM order_items oi " +
                "JOIN menu m ON oi.menuId = m.menuId WHERE oi.orderId=?");
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem i = new OrderItem();
                i.setOrderItemId(rs.getInt("orderItemId"));
                i.setOrderId    (rs.getInt("orderId"));
                i.setMenuId     (rs.getInt("menuId"));
                i.setQuantity   (rs.getInt("quantity"));
                i.setPrice      (rs.getDouble("price"));
                i.setName       (rs.getString("name"));
                i.setImage      (rs.getString("image"));
                i.setVeg        (rs.getBoolean("isVeg"));
                items.add(i);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "[AdminDAO] getOrderItemsForOrder failed", e);
        }
        return items;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE orders SET status=? WHERE orderId=?");
            ps.setString(1, status);
            ps.setInt   (2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] updateOrderStatus failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    // ══════════════════════════════════════════════════════════
    // USER MANAGEMENT
    // ══════════════════════════════════════════════════════════

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT u.*, " +
                "(SELECT COUNT(*) FROM orders o WHERE o.userId = u.userId) AS orderCount " +
                "FROM user u ORDER BY u.createdDate DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId   (rs.getInt    ("userId"));
                u.setUsername (rs.getString ("username"));
                u.setEmail    (rs.getString ("email"));
                u.setPhone    (rs.getString ("phone"));
                u.setAddress  (rs.getString ("address"));
                u.setRole     (rs.getString ("role"));
                u.setActive   (rs.getBoolean("isActive"));
                Timestamp ts = rs.getTimestamp("createdDate");
                if (ts != null) u.setCreatedDate(ts.toLocalDateTime());
                list.add(u);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getAllUsers failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return list;
    }

    @Override
    public User getUserById(int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM user WHERE userId=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId  (rs.getInt    ("userId"));
                u.setUsername(rs.getString ("username"));
                u.setEmail   (rs.getString ("email"));
                u.setPhone   (rs.getString ("phone"));
                u.setRole    (rs.getString ("role"));
                u.setActive  (rs.getBoolean("isActive"));
                return u;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] getUserById failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return null;
    }

    @Override
    public boolean toggleUserStatus(int userId, boolean isActive) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE user SET isActive=? WHERE userId=?");
            ps.setBoolean(1, isActive);
            ps.setInt    (2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[AdminDAO] toggleUserStatus failed", e);
        } finally { DBConnection.closeConnection(conn); }
        return false;
    }

    // ══════════════════════════════════════════════════════════
    // HELPERS
    // ══════════════════════════════════════════════════════════

    private int countQuery(String sql) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "[AdminDAO] countQuery failed: " + sql, e);
        } finally { DBConnection.closeConnection(conn); }
        return 0;
    }

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId  (rs.getInt    ("restaurantId"));
        r.setName          (rs.getString ("name"));
        r.setAddress       (rs.getString ("address"));
        r.setCity          (rs.getString ("city"));
        r.setPhone         (rs.getString ("phone"));
        r.setRatings       (rs.getDouble ("ratings"));
        r.setActive        (rs.getBoolean("isActive"));
        r.setImagePath     (rs.getString ("imagePath"));
        r.setDeliveryTime  (rs.getInt    ("deliveryTime"));
        r.setDeliveryFee   (rs.getDouble ("deliveryFee"));
        r.setMinOrderAmount(rs.getDouble ("minOrderAmount"));
        r.setDescription   (rs.getString ("description"));
        r.setCuisineType   (rs.getString ("cuisineType"));
        r.setColorPrimary  (rs.getString ("colorPrimary"));
        r.setColorSecondary(rs.getString ("colorSecondary"));
        r.setOfferText     (rs.getString ("offerText"));
        Timestamp ts = rs.getTimestamp("createdDate");
        if (ts != null) r.setCreatedDate(ts.toLocalDateTime());
        return r;
    }

    private MenuItem mapMenuItem(ResultSet rs) throws SQLException {
        MenuItem m = new MenuItem();
        m.setMenuId      (rs.getInt    ("menuId"));
        m.setRestaurantId(rs.getInt    ("restaurantId"));
        m.setName        (rs.getString ("name"));
        m.setPrice       (rs.getDouble ("price"));
        m.setDescription (rs.getString ("description"));
        m.setImage       (rs.getString ("image"));
        m.setVeg         (rs.getBoolean("isVeg"));
        m.setBestseller  (rs.getBoolean("isBestseller"));
        m.setAvailable   (rs.getBoolean("isAvailable"));
        m.setCategory    (rs.getString ("category"));
        m.setSpiceLevel  (rs.getString ("spiceLevel"));
        try { m.setRestaurantId(rs.getInt("restaurantId")); } catch (Exception ignored) {}
        return m;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
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
        Timestamp orderDate = rs.getTimestamp("orderDate");
        if (orderDate != null) o.setOrderDate(orderDate.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        if (updatedAt != null) o.setUpdatedAt(updatedAt.toLocalDateTime());
        return o;
    }
}

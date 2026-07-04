package com.tap.daoimpl;

import com.tap.dao.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * RestaurantDAOImpl.java
 * Location: src/main/java/com/tap/daoimpl/RestaurantDAOImpl.java
 */
public class RestaurantDAOImpl implements RestaurantDAO {

    private static final Logger LOGGER =
            Logger.getLogger(RestaurantDAOImpl.class.getName());

    // ─── Base SELECT — always reuse this ─────────────────────
    private static final String BASE_SELECT =
        "SELECT restaurantId, name, address, city, phone, ratings, isActive, " +
        "       imagePath, deliveryTime, deliveryFee, minOrderAmount, " +
        "       description, cuisineType, colorPrimary, colorSecondary, " +
        "       offerText, createdDate " +
        "FROM restaurant ";

    private static final String SQL_ALL_ACTIVE =
        BASE_SELECT + "WHERE isActive = 1 ORDER BY ratings DESC";

    private static final String SQL_BY_ID =
        BASE_SELECT + "WHERE restaurantId = ? AND isActive = 1";

    private static final String SQL_SEARCH =
        BASE_SELECT +
        "WHERE isActive = 1 AND " +
        "(LOWER(name) LIKE LOWER(?) OR LOWER(cuisineType) LIKE LOWER(?) " +
        " OR LOWER(address) LIKE LOWER(?)) " +
        "ORDER BY ratings DESC";

    private static final String SQL_TOP_RATED =
        BASE_SELECT + "WHERE isActive = 1 AND ratings >= 4.5 ORDER BY ratings DESC";

    private static final String SQL_BY_DELIVERY_TIME =
        BASE_SELECT + "WHERE isActive = 1 ORDER BY deliveryTime ASC";

    private static final String SQL_VEG_RESTAURANTS =
        "SELECT DISTINCT r.restaurantId, r.name, r.address, r.city, r.phone, " +
        "r.ratings, r.isActive, r.imagePath, r.deliveryTime, r.deliveryFee, " +
        "r.minOrderAmount, r.description, r.cuisineType, r.colorPrimary, " +
        "r.colorSecondary, r.offerText, r.createdDate " +
        "FROM restaurant r " +
        "INNER JOIN menu m ON r.restaurantId = m.restaurantId " +
        "WHERE r.isActive = 1 AND m.isVeg = 1 AND m.isAvailable = 1 " +
        "GROUP BY r.restaurantId " +
        "HAVING SUM(CASE WHEN m.isVeg = 0 THEN 1 ELSE 0 END) = 0 " +
        "ORDER BY r.ratings DESC";

    private static final String SQL_BY_CUISINE =
        BASE_SELECT +
        "WHERE isActive = 1 AND LOWER(cuisineType) LIKE LOWER(?) " +
        "ORDER BY ratings DESC";

    // ─────────────────────────────────────────────────────────
    // GET ALL ACTIVE
    // ─────────────────────────────────────────────────────────
    @Override
    public List<Restaurant> getAllActiveRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_ALL_ACTIVE);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[RestaurantDAO] getAllActiveRestaurants failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // GET BY ID
    // ─────────────────────────────────────────────────────────
    @Override
    public Restaurant getRestaurantById(int restaurantId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_BY_ID);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[RestaurantDAO] getRestaurantById failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // ─────────────────────────────────────────────────────────
    // SEARCH
    // ─────────────────────────────────────────────────────────
    @Override
    public List<Restaurant> searchRestaurants(String keyword) {
        List<Restaurant> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_SEARCH);
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[RestaurantDAO] searchRestaurants failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // TOP RATED
    // ─────────────────────────────────────────────────────────
    @Override
    public List<Restaurant> getTopRatedRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_TOP_RATED);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[RestaurantDAO] getTopRatedRestaurants failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // BY DELIVERY TIME
    // ─────────────────────────────────────────────────────────
    @Override
    public List<Restaurant> getRestaurantsByDeliveryTime() {
        List<Restaurant> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_BY_DELIVERY_TIME);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[RestaurantDAO] getRestaurantsByDeliveryTime failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // VEG RESTAURANTS
    // ─────────────────────────────────────────────────────────
    @Override
    public List<Restaurant> getVegRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_VEG_RESTAURANTS);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[RestaurantDAO] getVegRestaurants failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // BY CUISINE
    // ─────────────────────────────────────────────────────────
    @Override
    public List<Restaurant> getRestaurantsByCuisine(String cuisineType) {
        List<Restaurant> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_BY_CUISINE);
            ps.setString(1, "%" + cuisineType + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[RestaurantDAO] getRestaurantsByCuisine failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // PRIVATE HELPER — Map ResultSet row → Restaurant object
    // ─────────────────────────────────────────────────────────
    private Restaurant mapRow(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId  (rs.getInt   ("restaurantId"));
        r.setName          (rs.getString("name"));
        r.setAddress       (rs.getString("address"));
        r.setCity          (rs.getString("city"));
        r.setPhone         (rs.getString("phone"));
        r.setRatings       (rs.getDouble("ratings"));
        r.setActive        (rs.getBoolean("isActive"));
        r.setImagePath     (rs.getString("imagePath"));
        r.setDeliveryTime  (rs.getInt   ("deliveryTime"));
        r.setDeliveryFee   (rs.getDouble("deliveryFee"));
        r.setMinOrderAmount(rs.getDouble("minOrderAmount"));
        r.setDescription   (rs.getString("description"));
        r.setCuisineType   (rs.getString("cuisineType"));
        r.setColorPrimary  (rs.getString("colorPrimary"));
        r.setColorSecondary(rs.getString("colorSecondary"));
        r.setOfferText     (rs.getString("offerText"));

        Timestamp ts = rs.getTimestamp("createdDate");
        if (ts != null) r.setCreatedDate(ts.toLocalDateTime());

        return r;
    }
}

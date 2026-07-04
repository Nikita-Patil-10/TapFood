package com.tap.daoimpl;

import com.tap.dao.MenuDAO;
import com.tap.model.MenuItem;
import com.tap.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * MenuDAOImpl.java
 * Location: src/main/java/com/tap/daoimpl/MenuDAOImpl.java
 */
public class MenuDAOImpl implements MenuDAO {

    private static final Logger LOGGER =
            Logger.getLogger(MenuDAOImpl.class.getName());

    private static final String BASE_SELECT =
        "SELECT menuId, restaurantId, name, price, description, image, " +
        "       isVeg, isBestseller, isAvailable, category, spiceLevel, createdDate " +
        "FROM menu ";

    private static final String SQL_BY_RESTAURANT =
        BASE_SELECT +
        "WHERE restaurantId = ? AND isAvailable = 1 " +
        "ORDER BY isBestseller DESC, category ASC, name ASC";

    private static final String SQL_BY_CATEGORY =
        BASE_SELECT +
        "WHERE restaurantId = ? AND category = ? AND isAvailable = 1 " +
        "ORDER BY isBestseller DESC, name ASC";

    private static final String SQL_BY_ID =
        BASE_SELECT + "WHERE menuId = ?";

    private static final String SQL_BESTSELLERS =
        BASE_SELECT +
        "WHERE restaurantId = ? AND isBestseller = 1 AND isAvailable = 1 " +
        "ORDER BY name ASC";

    private static final String SQL_VEG_ITEMS =
        BASE_SELECT +
        "WHERE restaurantId = ? AND isVeg = 1 AND isAvailable = 1 " +
        "ORDER BY isBestseller DESC, name ASC";

    private static final String SQL_CATEGORIES =
        "SELECT DISTINCT category FROM menu " +
        "WHERE restaurantId = ? AND isAvailable = 1 AND category IS NOT NULL " +
        "ORDER BY category ASC";

    private static final String SQL_IS_AVAILABLE =
        "SELECT isAvailable FROM menu WHERE menuId = ?";

    // ─────────────────────────────────────────────────────────
    // GET MENU BY RESTAURANT
    // ─────────────────────────────────────────────────────────
    @Override
    public List<MenuItem> getMenuByRestaurant(int restaurantId) {
        List<MenuItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_BY_RESTAURANT);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] getMenuByRestaurant failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // GET MENU BY CATEGORY
    // ─────────────────────────────────────────────────────────
    @Override
    public List<MenuItem> getMenuByCategory(int restaurantId, String category) {
        List<MenuItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_BY_CATEGORY);
            ps.setInt   (1, restaurantId);
            ps.setString(2, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] getMenuByCategory failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // GET ITEM BY ID
    // ─────────────────────────────────────────────────────────
    @Override
    public MenuItem getMenuItemById(int menuId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_BY_ID);
            ps.setInt(1, menuId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] getMenuItemById failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // ─────────────────────────────────────────────────────────
    // GET BESTSELLERS
    // ─────────────────────────────────────────────────────────
    @Override
    public List<MenuItem> getBestsellers(int restaurantId) {
        List<MenuItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_BESTSELLERS);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] getBestsellers failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // GET VEG ITEMS
    // ─────────────────────────────────────────────────────────
    @Override
    public List<MenuItem> getVegItems(int restaurantId) {
        List<MenuItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_VEG_ITEMS);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] getVegItems failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // GET CATEGORIES
    // ─────────────────────────────────────────────────────────
    @Override
    public List<String> getCategoriesByRestaurant(int restaurantId) {
        List<String> categories = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_CATEGORIES);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) categories.add(rs.getString("category"));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] getCategoriesByRestaurant failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return categories;
    }

    // ─────────────────────────────────────────────────────────
    // IS ITEM AVAILABLE
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean isItemAvailable(int menuId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_IS_AVAILABLE);
            ps.setInt(1, menuId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBoolean("isAvailable");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] isItemAvailable failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    // ─────────────────────────────────────────────────────────
    // SEARCH MENU ITEMS BY NAME / DESCRIPTION
    // ─────────────────────────────────────────────────────────
    @Override
    public List<MenuItem> searchMenuItems(String keyword) {
        List<MenuItem> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = BASE_SELECT +
                "WHERE isAvailable = 1 AND " +
                "(LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?) " +
                " OR LOWER(category) LIKE LOWER(?)) " +
                "ORDER BY isBestseller DESC, name ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[MenuDAO] searchMenuItems failed", e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────
    // PRIVATE HELPER — Map ResultSet row → MenuItem object
    // ─────────────────────────────────────────────────────────
    private MenuItem mapRow(ResultSet rs) throws SQLException {
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

        Timestamp ts = rs.getTimestamp("createdDate");
        if (ts != null) m.setCreatedDate(ts.toLocalDateTime());

        return m;
    }
}

package com.tap.daoimpl;

import com.tap.dao.UserDAO;
import com.tap.model.User;
import com.tap.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * UserDAOImpl.java
 * Location: src/main/java/com/tap/daoimpl/UserDAOImpl.java
 *
 * JDBC implementation of UserDAO.
 * All SQL uses PreparedStatements — no SQL injection possible.
 */
public class UserDAOImpl implements UserDAO {

    private static final Logger LOGGER =
            Logger.getLogger(UserDAOImpl.class.getName());

    // ─── SQL Queries ──────────────────────────────────────────
    private static final String SQL_REGISTER =
        "INSERT INTO user (username, password, email, phone, address, role, isActive) " +
        "VALUES (?, ?, ?, ?, ?, ?, 1)";

    private static final String SQL_GET_BY_EMAIL =
        "SELECT userId, username, password, email, phone, address, role, isActive, createdDate " +
        "FROM user WHERE email = ? AND isActive = 1";

    private static final String SQL_GET_BY_ID =
        "SELECT userId, username, password, email, phone, address, role, isActive, createdDate " +
        "FROM user WHERE userId = ? AND isActive = 1";

    private static final String SQL_EMAIL_EXISTS =
        "SELECT COUNT(*) FROM user WHERE email = ?";

    private static final String SQL_UPDATE_PROFILE =
        "UPDATE user SET username = ?, phone = ?, address = ? WHERE userId = ?";

    private static final String SQL_UPDATE_PASSWORD =
        "UPDATE user SET password = ? WHERE userId = ?";

    // ─────────────────────────────────────────────────────────
    // REGISTER USER
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean registerUser(User user) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_REGISTER);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword()); // already BCrypt hashed
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole() != null ? user.getRole() : "CUSTOMER");

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] registerUser failed: " + e.getMessage(), e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // GET BY EMAIL
    // ─────────────────────────────────────────────────────────
    @Override
    public User getUserByEmail(String email) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_EMAIL);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getUserByEmail failed: " + e.getMessage(), e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // ─────────────────────────────────────────────────────────
    // GET BY ID
    // ─────────────────────────────────────────────────────────
    @Override
    public User getUserById(int userId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_ID);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToUser(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getUserById failed: " + e.getMessage(), e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // ─────────────────────────────────────────────────────────
    // EMAIL EXISTS
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean emailExists(String email) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_EMAIL_EXISTS);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] emailExists failed: " + e.getMessage(), e);
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    // ─────────────────────────────────────────────────────────
    // UPDATE PROFILE
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean updateProfile(User user) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_PROFILE);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setInt   (4, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] updateProfile failed: " + e.getMessage(), e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // UPDATE PASSWORD
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean updatePassword(int userId, String newPassword) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_PASSWORD);
            ps.setString(1, newPassword); // must be BCrypt hashed by caller
            ps.setInt   (2, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] updatePassword failed: " + e.getMessage(), e);
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // ─────────────────────────────────────────────────────────
    // PRIVATE HELPER — Map ResultSet row → User object
    // ─────────────────────────────────────────────────────────
    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId   (rs.getInt   ("userId"));
        user.setUsername (rs.getString("username"));
        user.setPassword (rs.getString("password"));
        user.setEmail    (rs.getString("email"));
        user.setPhone    (rs.getString("phone"));
        user.setAddress  (rs.getString("address"));
        user.setRole     (rs.getString("role"));
        user.setActive   (rs.getBoolean("isActive"));

        Timestamp ts = rs.getTimestamp("createdDate");
        if (ts != null) {
            user.setCreatedDate(ts.toLocalDateTime());
        }
        return user;
    }
}

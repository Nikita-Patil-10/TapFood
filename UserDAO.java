package com.tap.dao;

import com.tap.model.User;

/**
 * UserDAO.java
 * Location: src/main/java/com/tap/dao/UserDAO.java
 *
 * Interface defining all DB operations for the User entity.
 * Implementation: com.tap.daoimpl.UserDAOImpl
 */
public interface UserDAO {

    /** Register a new user. Password must be BCrypt-hashed before calling. */
    boolean registerUser(User user);

    /** Find user by email — used during login. Returns null if not found. */
    User getUserByEmail(String email);

    /** Find user by primary key. Returns null if not found. */
    User getUserById(int userId);

    /** Check if email is already registered — used during registration. */
    boolean emailExists(String email);

    /** Update profile (username, phone, address). Does NOT touch password. */
    boolean updateProfile(User user);

    /** Update password. newPassword must be BCrypt-hashed. */
    boolean updatePassword(int userId, String newPassword);
}

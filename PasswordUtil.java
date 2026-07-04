package com.tap.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * PasswordUtil.java
 * Location: src/main/java/com/tap/util/PasswordUtil.java
 */
public final class PasswordUtil {

    private static final int COST = 12;

    private PasswordUtil() {}

    /** Hash a plain-text password — store the result in the DB */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty())
            throw new IllegalArgumentException("Password must not be null or empty");
        return BCrypt.withDefaults().hashToString(COST, plainPassword.toCharArray());
    }

    /** Verify plain-text password against stored BCrypt hash */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        return BCrypt.verifyer()
                     .verify(plainPassword.toCharArray(), hashedPassword)
                     .verified;
    }
}

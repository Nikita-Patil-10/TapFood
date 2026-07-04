package com.tap.util;

import java.util.regex.Pattern;

/**
 * ValidationUtil.java
 * Location: src/main/java/com/tap/util/ValidationUtil.java
 */
public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile(AppConstants.EMAIL_REGEX);
    private static final Pattern PHONE_PATTERN =
            Pattern.compile(AppConstants.PHONE_REGEX);

    private ValidationUtil() {}

    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isNotNullOrEmpty(String value) {
        return !isNullOrEmpty(value);
    }

    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (isNullOrEmpty(phone)) return false;
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidPassword(String password) {
        if (isNullOrEmpty(password)) return false;
        return password.length() >= AppConstants.PASSWORD_MIN_LENGTH;
    }

    public static boolean isPositiveInt(String value) {
        if (isNullOrEmpty(value)) return false;
        try { return Integer.parseInt(value.trim()) > 0; }
        catch (NumberFormatException e) { return false; }
    }

    public static int parsePositiveInt(String value, int defaultValue) {
        try {
            int v = Integer.parseInt(value.trim());
            return v > 0 ? v : defaultValue;
        } catch (Exception e) { return defaultValue; }
    }

    /** Escape HTML special chars — basic XSS prevention */
    public static String sanitize(String input) {
        if (input == null) return null;
        return input.trim()
                    .replace("&",  "&amp;")
                    .replace("<",  "&lt;")
                    .replace(">",  "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'",  "&#x27;");
    }

    public static String sanitizeOrNull(String input) {
        if (isNullOrEmpty(input)) return null;
        return sanitize(input);
    }

    /** Returns error message string if invalid, null if everything is OK */
    public static String validateRegistration(String username, String email,
                                               String password, String confirmPassword) {
        if (isNullOrEmpty(username))
            return "Username is required.";
        if (username.trim().length() > AppConstants.USERNAME_MAX_LENGTH)
            return "Username too long (max " + AppConstants.USERNAME_MAX_LENGTH + " chars).";
        if (!isValidEmail(email))
            return "Please enter a valid email address.";
        if (!isValidPassword(password))
            return "Password must be at least " + AppConstants.PASSWORD_MIN_LENGTH + " characters.";
        if (!password.equals(confirmPassword))
            return "Passwords do not match.";
        return null;
    }
}

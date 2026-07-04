package com.tap.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBConnection.java
 * Location: src/main/java/com/tap/util/DBConnection.java
 *
 * Thread-safe JDBC connection pool.
 * Reads credentials from db.properties — never hardcoded.
 *
 * IMPORTANT: Static block does NOT throw ExceptionInInitializerError.
 * Errors are logged but Tomcat is allowed to start cleanly.
 */
public class DBConnection {

    private static final Logger LOGGER =
            Logger.getLogger(DBConnection.class.getName());

    private static String DB_DRIVER;
    private static String DB_URL;
    private static String DB_USERNAME;
    private static String DB_PASSWORD;
    private static int    POOL_INITIAL_SIZE = 5;
    private static int    POOL_MAX_SIZE     = 20;

    private static BlockingQueue<Connection> connectionPool;
    private static boolean poolInitialised = false;

    // ── Static initialiser — logs errors, does NOT crash Tomcat ──────────
    static {
        try {
            loadProperties();
            Class.forName(DB_DRIVER);
            initPool();
            poolInitialised = true;
            LOGGER.info("[TapFood] ✅ DB pool ready. Size: " + POOL_INITIAL_SIZE);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE,
                "[TapFood] ❌ MySQL JDBC Driver not found! Add mysql-connector-java to pom.xml", e);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE,
                "[TapFood] ❌ Cannot read db.properties: " + e.getMessage(), e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE,
                "[TapFood] ❌ DB connection failed. Check db.properties credentials. " + e.getMessage(), e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE,
                "[TapFood] ❌ Unexpected error during DB init: " + e.getMessage(), e);
        }
    }

    private DBConnection() {}

    // ─── Load db.properties from classpath ───────────────────────────────
    private static void loadProperties() throws IOException {
        Properties props = new Properties();
        try (InputStream is = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (is == null) {
                throw new IOException(
                    "db.properties not found in classpath. " +
                    "Make sure it is in src/main/resources/");
            }
            props.load(is);
        }

        DB_DRIVER         = props.getProperty("db.driver",           "com.mysql.cj.jdbc.Driver");
        DB_URL            = props.getProperty("db.url");
        DB_USERNAME       = props.getProperty("db.username");
        DB_PASSWORD       = props.getProperty("db.password", "");
        POOL_INITIAL_SIZE = Integer.parseInt(props.getProperty("db.pool.initialSize", "5"));
        POOL_MAX_SIZE     = Integer.parseInt(props.getProperty("db.pool.maxSize",     "20"));

        if (DB_URL == null || DB_USERNAME == null) {
            throw new IllegalArgumentException(
                "db.url and db.username must be set in db.properties");
        }
    }

    // ─── Create pool with initial connections ────────────────────────────
    private static void initPool() throws SQLException {
        connectionPool = new ArrayBlockingQueue<>(POOL_MAX_SIZE);
        for (int i = 0; i < POOL_INITIAL_SIZE; i++) {
            connectionPool.offer(createNewConnection());
        }
    }

    private static Connection createNewConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }

    // ─── PUBLIC API ───────────────────────────────────────────────────────

    /**
     * Borrow a connection from the pool.
     * Always call closeConnection() in a finally block.
     */
    public static Connection getConnection() throws SQLException {
        if (!poolInitialised) {
            throw new SQLException(
                "[TapFood] DB pool not initialised. " +
                "Check db.properties and ensure MySQL is running.");
        }

        Connection conn = connectionPool.poll();

        if (conn == null) {
            // Pool empty — create a temporary connection
            LOGGER.warning("[TapFood] Pool empty — creating on-demand connection.");
            return createNewConnection();
        }

        // Validate the borrowed connection is still alive
        try {
            if (!conn.isValid(2)) {
                LOGGER.warning("[TapFood] Stale connection — replacing.");
                conn = createNewConnection();
            }
        } catch (SQLException e) {
            conn = createNewConnection();
        }

        return conn;
    }

    /**
     * Return a connection to the pool.
     * Call this in a finally block — never leak connections.
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    if (!connectionPool.offer(conn)) {
                        conn.close(); // Pool full — physically close
                    }
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING,
                    "[TapFood] Error returning connection to pool.", e);
            }
        }
    }

    /**
     * Silent rollback — call after a failed transaction.
     */
    public static void rollback(Connection conn) {
        if (conn != null) {
            try { conn.rollback(); }
            catch (SQLException e) {
                LOGGER.log(Level.WARNING, "[TapFood] Rollback failed.", e);
            }
        }
    }

    /**
     * Shutdown the pool — called from AppContextListener on app stop.
     */
    public static void shutdownPool() {
        if (connectionPool != null) {
            for (Connection conn : connectionPool) {
                try {
                    if (conn != null && !conn.isClosed()) conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING,
                        "[TapFood] Error closing connection on shutdown.", e);
                }
            }
            connectionPool.clear();
            LOGGER.info("[TapFood] DB pool shut down cleanly.");
        }
    }

    public static int getAvailableConnections() {
        return connectionPool == null ? 0 : connectionPool.size();
    }

    public static boolean isPoolInitialised() {
        return poolInitialised;
    }
}

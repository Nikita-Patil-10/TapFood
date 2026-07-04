package com.tap.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import java.util.logging.Logger;

/**
 * AppContextListener.java
 * Location: src/main/java/com/tap/util/AppContextListener.java
 *
 * Fires on Tomcat start and stop.
 *
 * IMPORTANT: NO @WebListener annotation here.
 * It is registered ONLY in web.xml via <listener> tag.
 * Using both causes double-registration and Tomcat startup crash.
 */
public class AppContextListener implements ServletContextListener {

    private static final Logger LOGGER =
            Logger.getLogger(AppContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("============================================");
        LOGGER.info("   TapFood Application Starting...         ");
        LOGGER.info("============================================");

        try {
            // Touch DBConnection to trigger its static initialiser
            int available = DBConnection.getAvailableConnections();
            boolean poolOk = DBConnection.isPoolInitialised();

            if (poolOk) {
                LOGGER.info("[TapFood] ✅ DB pool ready. Connections: " + available);
            } else {
                LOGGER.warning("[TapFood] ⚠ DB pool NOT ready. " +
                    "Check db.properties and MySQL connection.");
            }

            // Publish app-wide values accessible in all JSPs via ${appName} etc.
            sce.getServletContext().setAttribute("appName",        AppConstants.APP_NAME);
            sce.getServletContext().setAttribute("appTagline",     AppConstants.APP_TAGLINE);
            sce.getServletContext().setAttribute("brandPrimary",   AppConstants.BRAND_PRIMARY);
            sce.getServletContext().setAttribute("brandSecondary", AppConstants.BRAND_SECONDARY);

            LOGGER.info("[TapFood] ✅ Application started successfully!");

        } catch (Exception e) {
            // Log but do NOT rethrow — let Tomcat continue starting
            LOGGER.severe("[TapFood] ❌ Error during startup: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("[TapFood] Shutting down — releasing DB connections...");
        DBConnection.shutdownPool();
        LOGGER.info("[TapFood] Shutdown complete. Goodbye!");
    }
}

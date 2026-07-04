package com.tap.servlet;

import com.tap.util.AppConstants;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * LogoutServlet.java
 * Location: src/main/java/com/tap/servlet/LogoutServlet.java
 *
 * GET /logout → invalidates session and redirects to home
 */
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Create fresh session just to carry the success message
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute(AppConstants.SESSION_MSG_SUCCESS,
                AppConstants.MSG_LOGOUT_SUCCESS);

        response.sendRedirect(
            request.getContextPath() + AppConstants.URL_HOME);
    }
}

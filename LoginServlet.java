package com.tap.servlet;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;
import com.tap.util.AppConstants;
import com.tap.util.PasswordUtil;
import com.tap.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * LoginServlet.java
 * Location: src/main/java/com/tap/servlet/LoginServlet.java
 *
 * GET  /login  → show login page
 * POST /login  → authenticate user
 */
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    // ─── GET: Show Login Page ─────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Already logged in → redirect home
        HttpSession session = request.getSession(false);
        if (session != null &&
            session.getAttribute(AppConstants.SESSION_USER) != null) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        request.setAttribute("pageTitle", "Login — TapFood");
        request.getRequestDispatcher(AppConstants.JSP_LOGIN)
               .forward(request, response);
    }

    // ─── POST: Authenticate ───────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation
        if (ValidationUtil.isNullOrEmpty(email) ||
            ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("error", "Email and password are required.");
            request.setAttribute("pageTitle", "Login — TapFood");
            request.getRequestDispatcher(AppConstants.JSP_LOGIN)
                   .forward(request, response);
            return;
        }

        // Look up user
        User user = userDAO.getUserByEmail(email.trim().toLowerCase());

        // Verify BCrypt password
        if (user == null || !PasswordUtil.verifyPassword(password, user.getPassword())) {
            request.setAttribute("error", AppConstants.ERR_INVALID_CREDENTIALS);
            request.setAttribute("emailValue", email); // preserve typed email
            request.setAttribute("pageTitle", "Login — TapFood");
            request.getRequestDispatcher(AppConstants.JSP_LOGIN)
                   .forward(request, response);
            return;
        }

        // ── Success — create session ──────────────────────────
        // Invalidate old session first (session fixation prevention)
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) oldSession.invalidate();

        HttpSession session = request.getSession(true);
        session.setAttribute(AppConstants.SESSION_USER, user);
        session.setAttribute(AppConstants.SESSION_MSG_SUCCESS,
                AppConstants.MSG_LOGIN_SUCCESS);

        // Set cart count
        com.tap.dao.CartDAO cartDAO = new com.tap.daoimpl.CartDAOImpl();
        int cartCount = cartDAO.getCartCount(user.getUserId());
        session.setAttribute(AppConstants.SESSION_CART_COUNT, cartCount);

        // Redirect to originally requested URL (if any) or home
        String redirectURL = (String) session.getAttribute("redirectAfterLogin");
        session.removeAttribute("redirectAfterLogin");

        if (redirectURL != null && !redirectURL.contains("/login")) {
            response.sendRedirect(redirectURL);
        } else {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
        }
    }
}

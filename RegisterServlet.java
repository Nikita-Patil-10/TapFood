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
 * RegisterServlet.java
 * Location: src/main/java/com/tap/servlet/RegisterServlet.java
 *
 * GET  /register → show registration form
 * POST /register → create account
 */
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    // ─── GET: Show Register Page ──────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null &&
            session.getAttribute(AppConstants.SESSION_USER) != null) {
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_HOME);
            return;
        }

        request.setAttribute("pageTitle", "Create Account — TapFood");
        request.getRequestDispatcher(AppConstants.JSP_REGISTER)
               .forward(request, response);
    }

    // ─── POST: Create Account ─────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username        = request.getParameter("username");
        String email           = request.getParameter("email");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone           = request.getParameter("phone");
        String address         = request.getParameter("address");

        // Preserve form values on error
        request.setAttribute("usernameValue", username);
        request.setAttribute("emailValue",    email);
        request.setAttribute("phoneValue",    phone);
        request.setAttribute("addressValue",  address);
        request.setAttribute("pageTitle",     "Create Account — TapFood");

        // Validate
        String validationError = ValidationUtil.validateRegistration(
                username, email, password, confirmPassword);

        if (validationError != null) {
            request.setAttribute("error", validationError);
            request.getRequestDispatcher(AppConstants.JSP_REGISTER)
                   .forward(request, response);
            return;
        }

        // Check duplicate email
        if (userDAO.emailExists(email.trim().toLowerCase())) {
            request.setAttribute("error", AppConstants.ERR_EMAIL_EXISTS);
            request.getRequestDispatcher(AppConstants.JSP_REGISTER)
                   .forward(request, response);
            return;
        }

        // Build user object
        User user = new User();
        user.setUsername(ValidationUtil.sanitize(username));
        user.setEmail   (email.trim().toLowerCase());
        user.setPassword(PasswordUtil.hashPassword(password)); // BCrypt hash
        user.setPhone   (ValidationUtil.sanitizeOrNull(phone));
        user.setAddress (ValidationUtil.sanitizeOrNull(address));
        user.setRole    (AppConstants.ROLE_CUSTOMER);
        user.setActive  (true);

        boolean registered = userDAO.registerUser(user);

        if (registered) {
            HttpSession session = request.getSession(true);
            session.setAttribute(AppConstants.SESSION_MSG_SUCCESS,
                    AppConstants.MSG_REGISTER_SUCCESS);
            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_LOGIN);
        } else {
            request.setAttribute("error", AppConstants.ERR_GENERIC);
            request.getRequestDispatcher(AppConstants.JSP_REGISTER)
                   .forward(request, response);
        }
    }
}

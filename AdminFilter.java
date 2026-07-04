package com.tap.util;

import com.tap.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * AdminFilter.java
 * Location: src/main/java/com/tap/util/AdminFilter.java
 *
 * Protects all /admin/* routes.
 * Only ADMIN role users can access. Others get 403.
 * Registered in web.xml.
 */
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest req,
                         ServletResponse res,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        User user = (session != null)
                ? (User) session.getAttribute(AppConstants.SESSION_USER)
                : null;

        if (user != null && "ADMIN".equals(user.getRole())) {
            chain.doFilter(request, response);
        } else if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            // Logged in but not admin
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Access denied. Admin only area.");
        }
    }

    @Override
    public void destroy() {}
}

package com.tap.util;

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
 * AuthFilter.java
 * Location: src/main/java/com/tap/util/AuthFilter.java
 *
 * Protects: /cart  /checkout  /order  /orders
 * If not logged in → saves intended URL → redirects to /login
 * Registered in web.xml — NO @WebFilter annotation.
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest req,
                         ServletResponse res,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session  = request.getSession(false);
        boolean     loggedIn = (session != null)
                && (session.getAttribute(AppConstants.SESSION_USER) != null);

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            // Save the originally requested URL so we can redirect back after login
            String requestedURL = request.getRequestURI();
            String query        = request.getQueryString();
            if (query != null) requestedURL += "?" + query;

            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("redirectAfterLogin", requestedURL);
            newSession.setAttribute(AppConstants.SESSION_MSG_ERROR,
                    AppConstants.ERR_SESSION_EXPIRED);

            response.sendRedirect(
                request.getContextPath() + AppConstants.URL_LOGIN);
        }
    }

    @Override
    public void destroy() {}
}

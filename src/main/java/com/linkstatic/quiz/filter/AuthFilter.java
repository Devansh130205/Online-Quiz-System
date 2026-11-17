package com.linkstatic.quiz.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AuthFilter — protects all user-facing pages.
 * Redirects unauthenticated requests to the login page.
 */
@WebFilter(urlPatterns = {"/dashboard", "/quiz", "/submit-quiz", "/result"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  httpReq  = (HttpServletRequest)  request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        HttpSession session = httpReq.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("loggedUser") != null;

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResp.sendRedirect(httpReq.getContextPath() + "/login");
        }
    }

    @Override public void init(FilterConfig config)   throws ServletException {}
    @Override public void destroy()                                             {}
}

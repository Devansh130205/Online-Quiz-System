package com.linkstatic.quiz.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AdminAuthFilter — protects all /admin/* routes except /admin/login.
 */
@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  httpReq  = (HttpServletRequest)  request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        String uri = httpReq.getRequestURI();
        // Allow /admin/login through
        if (uri.endsWith("/admin/login")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpReq.getSession(false);
        boolean adminLoggedIn = session != null && session.getAttribute("loggedAdmin") != null;

        if (adminLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResp.sendRedirect(httpReq.getContextPath() + "/admin/login");
        }
    }

    @Override public void init(FilterConfig config)   throws ServletException {}
    @Override public void destroy()                                             {}
}

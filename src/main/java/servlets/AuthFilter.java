package servlets;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter({"/dashboard.jsp", "/canner.jsp"}) // protèges ces pages
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("email") == null) {
            res.sendRedirect(req.getContextPath() + "/Login.jsp");
            return;
        }


        chain.doFilter(request, response); // continuer normalement
    }
}

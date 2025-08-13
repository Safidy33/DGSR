package servlets;

import utils.Database;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("mot_de_passe");

        try (Connection conn = Database.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM utilisateur WHERE email = ? AND mot_de_passe = ?"
            );
            ps.setString(1, email);
            ps.setString(2, motDePasse);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("role", rs.getString("role"));

                if ("admin".equals(rs.getString("role"))) {
                    response.sendRedirect("dashboard.jsp");
                } else {
                    response.sendRedirect("canner.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

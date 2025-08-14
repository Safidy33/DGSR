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
        // Redirige vers la page de login si accès direct
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String motDePasse = request.getParameter("mot_de_passe");

        if (email == null || motDePasse == null || email.isEmpty() || motDePasse.isEmpty()) {
            // Champ vide
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=empty");
            return;
        }

        try (Connection conn = Database.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM utilisateur WHERE email = ? AND mot_de_passe = ?"
            );
            ps.setString(1, email);
            ps.setString(2, motDePasse);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Connexion réussie
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("role", rs.getString("role"));

                String role = rs.getString("role");
                if ("admin".equalsIgnoreCase(role)) {
                    // Redirection admin vers le servlet qui affiche le dashboard
                    response.sendRedirect(request.getContextPath() + "/PointageServlet");
                } else {
                    // Redirection utilisateur normal
                    response.sendRedirect(request.getContextPath() + "/canner.jsp");
                }

            } else {
                // Identifiants incorrects
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=server");
        }
    }
}

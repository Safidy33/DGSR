package servlets;

import utils.Database;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Pointage;

@WebServlet("/PointageServlet")
public class PointageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Pointage> derniersPointages = new ArrayList<>();
        int presentCount = 0;
        int absentCount = 0;
        int totalPersonnel = 0;

        try (Connection conn = Database.getConnection()) {
            // Récupérer les 10 derniers pointages
            String sql = "SELECT p.date_pointage, p.type, pe.nom, pe.prenom, p.statut " +
                         "FROM pointage p " +
                         "JOIN personnel pe ON p.personnel_id = pe.id " +
                         "ORDER BY p.date_pointage DESC " +
                         "LIMIT 10";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Pointage pointage = new Pointage();
                pointage.setDatePointage(rs.getTimestamp("date_pointage"));
                pointage.setType(rs.getString("type"));
                pointage.setNomPersonnel(rs.getString("nom"));
                pointage.setPrenomPersonnel(rs.getString("prenom"));
                pointage.setStatut(rs.getString("statut"));
                derniersPointages.add(pointage);
            }
            rs.close();
            ps.close();

            // Get total personnel count
            String sqlTotal = "SELECT COUNT(*) FROM personnel";
            PreparedStatement psTotal = conn.prepareStatement(sqlTotal);
            ResultSet rsTotal = psTotal.executeQuery();
            if (rsTotal.next()) {
                totalPersonnel = rsTotal.getInt(1);
            }
            rsTotal.close();
            psTotal.close();

            // Compter les personnels présents (ayant fait un pointage aujourd'hui)
            String sqlPresent = "SELECT COUNT(DISTINCT personnel_id) FROM pointage " +
                               "WHERE DATE(date_pointage) = CURRENT_DATE";
            PreparedStatement psPresent = conn.prepareStatement(sqlPresent);
            ResultSet rsPresent = psPresent.executeQuery();
            if (rsPresent.next()) {
                presentCount = rsPresent.getInt(1);
            }
            rsPresent.close();
            psPresent.close();

            // Calculer les absents (total - présents)
            absentCount = totalPersonnel - presentCount;

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("derniersPointages", derniersPointages);
        request.setAttribute("presentCount", presentCount);
        request.setAttribute("absentCount", absentCount);
        request.setAttribute("totalPersonnel", totalPersonnel);
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}

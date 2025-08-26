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
import models.Personnel;

@WebServlet("/PointageServlet")
public class PointageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("voir_presents".equals(action)) {
            // ✅ Page "Voir Présents"
            List<Personnel> personnelsPresents = getPersonnelsPresents();
            request.setAttribute("personnelsPresents", personnelsPresents);
            request.getRequestDispatcher("voir_presents.jsp").forward(request, response);

        } else if ("voir_absents".equals(action)) {
            // ✅ Page "Voir Absents"
            List<Personnel> personnelsAbsents = getPersonnelsAbsents();
            request.setAttribute("personnelsAbsents", personnelsAbsents);
            request.getRequestDispatcher("absents.jsp").forward(request, response);

        } else {
            // ✅ Dashboard par défaut
            List<Pointage> derniersPointages = new ArrayList<>();
            int presentCount = 0;
            int absentCount = 0;
            int totalPersonnel = 0;

            try (Connection conn = Database.getConnection()) {
                // Récupérer les 10 derniers pointages du jour
                String sql = "SELECT p.date_pointage, p.type, pe.nom, pe.prenom, p.statut " +
                             "FROM pointage p " +
                             "JOIN personnel pe ON p.personnel_id = pe.id " +
                             "WHERE DATE(p.date_pointage) = CURRENT_DATE " +
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

                // ✅ Total personnel
                String sqlTotal = "SELECT COUNT(*) FROM personnel";
                PreparedStatement psTotal = conn.prepareStatement(sqlTotal);
                ResultSet rsTotal = psTotal.executeQuery();
                if (rsTotal.next()) {
                    totalPersonnel = rsTotal.getInt(1);
                }
                rsTotal.close();
                psTotal.close();

                // ✅ Présents aujourd'hui
                String sqlPresent = "SELECT COUNT(DISTINCT personnel_id) FROM pointage " +
                                   "WHERE DATE(date_pointage) = CURRENT_DATE";
                PreparedStatement psPresent = conn.prepareStatement(sqlPresent);
                ResultSet rsPresent = psPresent.executeQuery();
                if (rsPresent.next()) {
                    presentCount = rsPresent.getInt(1);
                }
                rsPresent.close();
                psPresent.close();

                // ✅ Absents
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

    // ✅ Présents
    private List<Personnel> getPersonnelsPresents() {
        List<Personnel> personnelsPresents = new ArrayList<>();
        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT DISTINCT p.id, p.nom, p.prenom, p.numero_employe, p.departement, p.email, p.qr_code " +
                         "FROM personnel p " +
                         "JOIN pointage pt ON p.id = pt.personnel_id " +
                         "WHERE DATE(pt.date_pointage) = CURRENT_DATE " +
                         "ORDER BY p.nom, p.prenom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Personnel personnel = new Personnel();
                personnel.setId(rs.getInt("id"));
                personnel.setNom(rs.getString("nom"));
                personnel.setPrenom(rs.getString("prenom"));
                personnel.setNumeroEmploye(rs.getString("numero_employe"));
                personnel.setDepartement(rs.getString("departement"));
                personnel.setEmail(rs.getString("email"));
                personnel.setQrCode(rs.getString("qr_code"));
                personnelsPresents.add(personnel);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return personnelsPresents;
    }

    // ✅ Absents
    private List<Personnel> getPersonnelsAbsents() {
        List<Personnel> personnelsAbsents = new ArrayList<>();
        try (Connection conn = Database.getConnection()) {
            // Tous les personnels qui n'ont PAS pointé aujourd'hui
            String sql = "SELECT p.id, p.nom, p.prenom, p.numero_employe, p.departement, p.email, p.qr_code " +
                         "FROM personnel p " +
                         "WHERE p.id NOT IN ( " +
                         "   SELECT DISTINCT personnel_id FROM pointage WHERE DATE(date_pointage) = CURRENT_DATE " +
                         ") " +
                         "ORDER BY p.nom, p.prenom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Personnel personnel = new Personnel();
                personnel.setId(rs.getInt("id"));
                personnel.setNom(rs.getString("nom"));
                personnel.setPrenom(rs.getString("prenom"));
                personnel.setNumeroEmploye(rs.getString("numero_employe"));
                personnel.setDepartement(rs.getString("departement"));
                personnel.setEmail(rs.getString("email"));
                personnel.setQrCode(rs.getString("qr_code"));
                personnelsAbsents.add(personnel);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return personnelsAbsents;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("voir_presents".equals(action)) {
            List<Personnel> personnelsPresents = getPersonnelsPresents();
            request.setAttribute("personnelsPresents", personnelsPresents);
            request.getRequestDispatcher("voir_presents.jsp").forward(request, response);

        } else if ("voir_absents".equals(action)) {
            List<Personnel> personnelsAbsents = getPersonnelsAbsents();
            request.setAttribute("personnelsAbsents", personnelsAbsents);
            request.getRequestDispatcher("absents.jsp").forward(request, response);

        } else {
            response.sendRedirect("PointageServlet");
        }
    }
}

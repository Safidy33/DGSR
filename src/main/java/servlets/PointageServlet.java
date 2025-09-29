package servlets;

import utils.Database;
import java.io.IOException;
import java.sql.*;
import java.util.*;
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
            request.setAttribute("personnelsPresents", getPersonnelsPresents());
            request.getRequestDispatcher("voir_presents.jsp").forward(request, response);

        } else if ("voir_absents".equals(action)) {
            request.setAttribute("personnelsAbsents", getPersonnelsAbsents());
            request.getRequestDispatcher("absents.jsp").forward(request, response);

        } else if ("pointage".equals(action)) {
            List<Pointage> pointagesDuJour = getPointages(true);
            request.setAttribute("pointagesDuJour", pointagesDuJour);
            request.getRequestDispatcher("pointage.jsp").forward(request, response);

        } else {
            List<Pointage> derniersPointages = getPointages(false);
            int totalPersonnel = getTotalPersonnel();
            int presentCount = getPresentCount();
            int absentCount = totalPersonnel - presentCount;

            request.setAttribute("derniersPointages", derniersPointages);
            request.setAttribute("presentCount", presentCount);
            request.setAttribute("absentCount", absentCount);
            request.setAttribute("totalPersonnel", totalPersonnel);

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }

    // 🔹 Récupère et fusionne entrée/sortie
    private List<Pointage> getPointages(boolean tout) {
        List<Pointage> pointages = new ArrayList<>();
        try (Connection conn = Database.getConnection()) {
            String sql = """
                SELECT pe.nom, pe.prenom, p.type, p.date_pointage, p.statut, p.personnel_id, u.localisation
                FROM pointage p
                JOIN personnel pe ON p.personnel_id = pe.id
                LEFT JOIN utilisateur u ON p.scanner_id = u.id
                WHERE DATE(p.date_pointage) = CURRENT_DATE
                ORDER BY p.date_pointage ASC
                """ + (tout ? "" : " LIMIT 20");

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            Map<Integer, Pointage> currentEntreeMap = new HashMap<>();
            java.util.Calendar utcCalendar = java.util.Calendar.getInstance(java.util.TimeZone.getTimeZone("UTC"));

            while (rs.next()) {
                String nom = rs.getString("nom");
                String prenom = rs.getString("prenom");
                String type = rs.getString("type");
                Timestamp datePointage = rs.getTimestamp("date_pointage", utcCalendar);
                String statut = rs.getString("statut");
                int personnelId = rs.getInt("personnel_id");
                String localisation = rs.getString("localisation");

                if ("entree".equalsIgnoreCase(type)) {
                    Pointage entreePointage = new Pointage();
                    entreePointage.setNomPersonnel(nom);
                    entreePointage.setPrenomPersonnel(prenom);
                    entreePointage.setDatePointage(datePointage);
                    entreePointage.setStatut(statut);
                    entreePointage.setLocalisation(localisation);
                    currentEntreeMap.put(personnelId, entreePointage);
                } else if ("sortie".equalsIgnoreCase(type)) {
                    Pointage entreePointage = currentEntreeMap.get(personnelId);
                    if (entreePointage != null) {
                        entreePointage.setDateSortie(datePointage);
                        pointages.add(entreePointage);
                        currentEntreeMap.remove(personnelId);
                    } else {
                        Pointage sortiePointage = new Pointage();
                        sortiePointage.setNomPersonnel(nom);
                        sortiePointage.setPrenomPersonnel(prenom);
                        sortiePointage.setDateSortie(datePointage);
                        sortiePointage.setStatut(statut);
                        sortiePointage.setLocalisation(localisation);
                        pointages.add(sortiePointage);
                    }
                }
            }
            pointages.addAll(currentEntreeMap.values());

            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return pointages;
    }

    // 🔹 Présents
    private List<Personnel> getPersonnelsPresents() {
        List<Personnel> personnelsPresents = new ArrayList<>();
        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT DISTINCT p.id, p.nom, p.prenom, p.numero_employe, p.departement, p.email, p.qr_code " +
                         "FROM personnel p JOIN pointage pt ON p.id = pt.personnel_id " +
                         "WHERE DATE(pt.date_pointage) = CURRENT_DATE ORDER BY p.nom, p.prenom";
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
        } catch (Exception e) { e.printStackTrace(); }
        return personnelsPresents;
    }

    // 🔹 Absents
    private List<Personnel> getPersonnelsAbsents() {
        List<Personnel> personnelsAbsents = new ArrayList<>();
        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT p.id, p.nom, p.prenom, p.numero_employe, p.departement, p.email, p.qr_code " +
                         "FROM personnel p " +
                         "WHERE p.id NOT IN (SELECT DISTINCT personnel_id FROM pointage WHERE DATE(date_pointage) = CURRENT_DATE) " +
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
        } catch (Exception e) { e.printStackTrace(); }
        return personnelsAbsents;
    }

    // 🔹 Compteurs
    private int getTotalPersonnel() {
        try (Connection conn = Database.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM personnel");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private int getPresentCount() {
        try (Connection conn = Database.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(DISTINCT personnel_id) FROM pointage WHERE DATE(date_pointage) = CURRENT_DATE");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // 🔁 réutiliser la logique
    }
}

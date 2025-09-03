package servlets;

import utils.Database;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import models.Pointage;
import models.Personnel;

@WebServlet("/StatistiqueServlet")
public class StatistiqueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer tous les personnels
        List<Personnel> tousPersonnels = getAllPersonnel();

        // Récupérer tous les départements
        List<String> tousDepartements = getAllDepartements();

        // Récupérer tous les pointages pour les statistiques
        List<Pointage> tousPointages = getTousPointages();

        // Calculer les statistiques globales
        Map<String, Object> statistiquesGlobales = calculerStatistiquesGlobales(tousPointages);

        // Calculer les statistiques par département
        Map<String, Map<String, Object>> statistiquesParDepartement = calculerStatistiquesParDepartement(tousPointages);

        // Obtenir les statuts actuels des personnels
        Map<String, List<Map<String, Object>>> statutsPersonnels = getStatutsPersonnelsParDepartement(null);

        // Définir les attributs pour la JSP
        request.setAttribute("tousPersonnels", tousPersonnels);
        request.setAttribute("tousDepartements", tousDepartements);
        request.setAttribute("statistiquesGlobales", statistiquesGlobales);
        request.setAttribute("statistiquesParDepartement", statistiquesParDepartement);
        request.setAttribute("statutsPersonnels", statutsPersonnels);

        // Transférer vers la page JSP
        request.getRequestDispatcher("statistique.jsp").forward(request, response);
    }

    private List<Pointage> getTousPointages() {
        List<Pointage> pointages = new ArrayList<>();

        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT p.date_pointage, p.type, pe.nom, pe.prenom, p.statut, pe.departement " +
                         "FROM pointage p " +
                         "JOIN personnel pe ON p.personnel_id = pe.id " +
                         "WHERE DATE(p.date_pointage) = CURRENT_DATE " +
                         "ORDER BY p.date_pointage DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Pointage pointage = new Pointage();
                pointage.setDatePointage(rs.getTimestamp("date_pointage"));
                pointage.setType(rs.getString("type"));
                pointage.setNomPersonnel(rs.getString("nom"));
                pointage.setPrenomPersonnel(rs.getString("prenom"));
                pointage.setStatut(rs.getString("statut"));
                pointage.setDepartement(rs.getString("departement"));
                pointages.add(pointage);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return pointages;
    }

    private List<Personnel> getAllPersonnel() {
        List<Personnel> personnels = new ArrayList<>();

        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT id, nom, prenom, numero_employe, departement, email FROM personnel ORDER BY nom, prenom";
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
                personnels.add(personnel);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return personnels;
    }

    private List<String> getAllDepartements() {
        List<String> departements = new ArrayList<>();

        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT DISTINCT departement FROM personnel WHERE departement IS NOT NULL ORDER BY departement";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                departements.add(rs.getString("departement"));
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return departements;
    }

    private Map<String, Object> calculerStatistiquesGlobales(List<Pointage> pointages) {
        Map<String, Object> stats = new HashMap<>();

        int totalPointages = pointages.size();
        int entrees = 0;
        int sorties = 0;
        Map<String, Integer> pointagesParPersonnel = new HashMap<>();
        Map<String, Integer> pointagesParDepartement = new HashMap<>();

        for (Pointage pt : pointages) {
            if ("entree".equalsIgnoreCase(pt.getType())) {
                entrees++;
            } else if ("sortie".equalsIgnoreCase(pt.getType())) {
                sorties++;
            }

            String nomComplet = pt.getNomPersonnel() + " " + pt.getPrenomPersonnel();
            pointagesParPersonnel.put(nomComplet, pointagesParPersonnel.getOrDefault(nomComplet, 0) + 1);

            String dept = pt.getDepartement() != null ? pt.getDepartement() : "Non spécifié";
            pointagesParDepartement.put(dept, pointagesParDepartement.getOrDefault(dept, 0) + 1);
        }

        stats.put("totalPointages", totalPointages);
        stats.put("entrees", entrees);
        stats.put("sorties", sorties);
        stats.put("pointagesParPersonnel", pointagesParPersonnel);
        stats.put("pointagesParDepartement", pointagesParDepartement);

        return stats;
    }

    private Map<String, Map<String, Object>> calculerStatistiquesParDepartement(List<Pointage> pointages) {
        Map<String, Map<String, Object>> statsParDept = new HashMap<>();

        for (Pointage pt : pointages) {
            String dept = pt.getDepartement() != null ? pt.getDepartement() : "Non spécifié";

            if (!statsParDept.containsKey(dept)) {
                Map<String, Object> deptStats = new HashMap<>();
                deptStats.put("total", 0);
                deptStats.put("entrees", 0);
                deptStats.put("sorties", 0);
                deptStats.put("personnels", new HashMap<String, Integer>());
                statsParDept.put(dept, deptStats);
            }

            Map<String, Object> deptStats = statsParDept.get(dept);
            deptStats.put("total", (Integer) deptStats.get("total") + 1);

            if ("entree".equalsIgnoreCase(pt.getType())) {
                deptStats.put("entrees", (Integer) deptStats.get("entrees") + 1);
            } else if ("sortie".equalsIgnoreCase(pt.getType())) {
                deptStats.put("sorties", (Integer) deptStats.get("sorties") + 1);
            }

            @SuppressWarnings("unchecked")
            Map<String, Integer> personnels = (Map<String, Integer>) deptStats.get("personnels");
            String nomComplet = pt.getNomPersonnel() + " " + pt.getPrenomPersonnel();
            personnels.put(nomComplet, personnels.getOrDefault(nomComplet, 0) + 1);
        }

        return statsParDept;
    }

    private Map<String, List<Map<String, Object>>> getStatutsPersonnelsParDepartement(String dateStr) {
        Map<String, List<Map<String, Object>>> result = new HashMap<>();

        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT id, nom, prenom, numero_employe, departement FROM personnel ORDER BY departement, nom, prenom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int personnelId = rs.getInt("id");
                String nom = rs.getString("nom");
                String prenom = rs.getString("prenom");
                String numeroTelephone = rs.getString("numero_employe");
                String departement = rs.getString("departement");

                if (departement == null) departement = "Non spécifié";

                String statut = "Absent";
                String remarques = "";

                // Vérifier s'il y a une entrée aujourd'hui
                String sqlPointage = "SELECT COUNT(*) FROM pointage WHERE personnel_id = ? AND DATE(date_pointage) = CURRENT_DATE AND type = 'entree'";
                PreparedStatement psPointage = conn.prepareStatement(sqlPointage);
                psPointage.setInt(1, personnelId);

                ResultSet rsPointage = psPointage.executeQuery();
                if (rsPointage.next() && rsPointage.getInt(1) > 0) {
                    statut = "Présent";
                }

                rsPointage.close();
                psPointage.close();

                Map<String, Object> personnelInfo = new HashMap<>();
                personnelInfo.put("id", personnelId);
                personnelInfo.put("nom", nom);
                personnelInfo.put("prenom", prenom);
                personnelInfo.put("matricule", numeroTelephone);
                personnelInfo.put("statut", statut);
                personnelInfo.put("remarques", remarques);

                if (!result.containsKey(departement)) {
                    result.put(departement, new ArrayList<>());
                }
                result.get(departement).add(personnelInfo);
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

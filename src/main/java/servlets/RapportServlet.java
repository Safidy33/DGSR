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

@WebServlet("/RapportServlet")
public class RapportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("generer_rapport".equals(action)) {
            // Récupérer les paramètres de filtrage
            String dateDebut = request.getParameter("date_debut");
            String personnelId = request.getParameter("personnel_id");
            String departement = request.getParameter("departement");
            String periode = request.getParameter("periode");

            // Générer le rapport avec les filtres (ignorer dateFin)
            List<Pointage> pointagesFiltres = getPointagesFiltres(dateDebut, null, personnelId, departement, periode);
            List<Personnel> tousPersonnels = getAllPersonnel();
            List<String> tousDepartements = getAllDepartements();

            // Calculer les statistiques
            Map<String, Object> statistiques = calculerStatistiques(pointagesFiltres);

            // Obtenir les statuts des personnels par département en fonction de la dateDebut
            Map<String, List<Map<String, Object>>> statutsPersonnels = getStatutsPersonnelsParDepartement(dateDebut);

            request.setAttribute("pointages", pointagesFiltres);
            request.setAttribute("tousPersonnels", tousPersonnels);
            request.setAttribute("tousDepartements", tousDepartements);
            request.setAttribute("statistiques", statistiques);
            request.setAttribute("statutsPersonnels", statutsPersonnels);
            request.setAttribute("dateDebut", dateDebut);
            request.setAttribute("personnelId", personnelId);
            request.setAttribute("departement", departement);
            request.setAttribute("periode", periode);
            
        } else {
            // Page de rapport par défaut
            List<Personnel> tousPersonnels = getAllPersonnel();
            List<String> tousDepartements = getAllDepartements();
            
            request.setAttribute("tousPersonnels", tousPersonnels);
            request.setAttribute("tousDepartements", tousDepartements);
        }
        
        request.getRequestDispatcher("rapport.jsp").forward(request, response);
    }

    private List<Pointage> getPointagesFiltres(String dateDebut, String dateFin, String personnelId, String departement, String periode) {
        List<Pointage> pointages = new ArrayList<>();
        
        try (Connection conn = Database.getConnection()) {
            StringBuilder sql = new StringBuilder(
                "SELECT p.date_pointage, p.type, pe.nom, pe.prenom, p.statut, pe.departement " +
                "FROM pointage p " +
                "JOIN personnel pe ON p.personnel_id = pe.id " +
                "WHERE 1=1"
            );

            // Appliquer les filtres
            if (dateDebut != null && !dateDebut.isEmpty()) {
                sql.append(" AND DATE(p.date_pointage) >= ?");
            }
            if (dateFin != null && !dateFin.isEmpty()) {
                sql.append(" AND DATE(p.date_pointage) <= ?");
            }
            if (personnelId != null && !personnelId.isEmpty() && !"tous".equals(personnelId)) {
                sql.append(" AND p.personnel_id = ?");
            }
            if (departement != null && !departement.isEmpty() && !"tous".equals(departement)) {
                sql.append(" AND pe.departement = ?");
            }

            // Appliquer la période prédéfinie
            if (periode != null && !periode.isEmpty()) {
                switch (periode) {
                    case "aujourdhui":
                        sql.append(" AND DATE(p.date_pointage) = CURRENT_DATE");
                        break;
                    case "semaine":
                        sql.append(" AND YEARWEEK(p.date_pointage) = YEARWEEK(CURRENT_DATE)");
                        break;
                    case "mois":
                        sql.append(" AND YEAR(p.date_pointage) = YEAR(CURRENT_DATE) AND MONTH(p.date_pointage) = MONTH(CURRENT_DATE)");
                        break;
                }
            }

            sql.append(" ORDER BY p.date_pointage DESC");

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (dateDebut != null && !dateDebut.isEmpty()) {
                ps.setString(paramIndex++, dateDebut);
            }
            if (dateFin != null && !dateFin.isEmpty()) {
                ps.setString(paramIndex++, dateFin);
            }
            if (personnelId != null && !personnelId.isEmpty() && !"tous".equals(personnelId)) {
                ps.setInt(paramIndex++, Integer.parseInt(personnelId));
            }
            if (departement != null && !departement.isEmpty() && !"tous".equals(departement)) {
                ps.setString(paramIndex++, departement);
            }

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

    private Map<String, Object> calculerStatistiques(List<Pointage> pointages) {
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
            
            // Pour les départements, nous aurions besoin de plus d'info dans Pointage
            // Pour l'instant, on va simplement compter par personnel
        }
        
        stats.put("totalPointages", totalPointages);
        stats.put("entrees", entrees);
        stats.put("sorties", sorties);
        stats.put("pointagesParPersonnel", pointagesParPersonnel);
        
        return stats;
    }

    // Méthode corrigée pour obtenir les statuts des personnels par département
    private Map<String, List<Map<String, Object>>> getStatutsPersonnelsParDepartement(String dateStr) {
        Map<String, List<Map<String, Object>>> result = new HashMap<>();
        
        try (Connection conn = Database.getConnection()) {
            // Récupérer tous les personnels avec leurs départements
            String sql = "SELECT id, nom, prenom, numero_employe, departement FROM personnel ORDER BY departement, nom, prenom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            // Convertir la date sélectionnée en Date
            java.util.Date selectedDate = null;
            if (dateStr != null && !dateStr.isEmpty()) {
                try {
                    selectedDate = java.sql.Date.valueOf(dateStr);
                } catch (IllegalArgumentException e) {
                    selectedDate = null;
                }
            }
            
            while (rs.next()) {
                int personnelId = rs.getInt("id");
                String nom = rs.getString("nom");
                String prenom = rs.getString("prenom");
                String numeroTelephone = rs.getString("numero_employe");
                String departement = rs.getString("departement");
                
                if (departement == null) departement = "Non spécifié";
                
                // Déterminer le statut du personnel pour la date sélectionnée
                String statut = "Absent";
                String remarques = "";
                
                // Si une date est sélectionnée, vérifier les pointages pour cette date spécifique
                if (selectedDate != null) {
                    // Requête pour vérifier s'il y a une entrée pour ce personnel à la date sélectionnée
                    String sqlPointage = "SELECT COUNT(*) FROM pointage WHERE personnel_id = ? AND DATE(date_pointage) = ? AND type = 'entree'";
                    PreparedStatement psPointage = conn.prepareStatement(sqlPointage);
                    psPointage.setInt(1, personnelId);
                    psPointage.setDate(2, new java.sql.Date(selectedDate.getTime()));
                    
                    ResultSet rsPointage = psPointage.executeQuery();
                    if (rsPointage.next() && rsPointage.getInt(1) > 0) {
                        statut = "Présent";
                    }
                    
                    rsPointage.close();
                    psPointage.close();
                }
                
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
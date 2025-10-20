package servlets;

import utils.Database;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
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
        
        // Toujours charger les listes pour les filtres
        List<Personnel> tousPersonnels = getAllPersonnel();
        List<String> tousDepartements = getAllDepartements();
        
        if ("generer_rapport".equals(action)) {
            // Récupérer les paramètres de filtrage
            String dateDebut = request.getParameter("date_debut");
            String personnelId = request.getParameter("personnel_id");
            String departement = request.getParameter("departement");
            String periode = request.getParameter("periode");

            // Si la date est vide, utiliser la date du jour
            if (dateDebut == null || dateDebut.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                dateDebut = sdf.format(new java.util.Date());
            }



            // Vérifier la cohérence entre personnel et département
            boolean personnelDepartementCoherent = true;
            if (personnelId != null && !personnelId.isEmpty() && !"tous".equals(personnelId) &&
                departement != null && !departement.isEmpty() && !"tous".equals(departement)) {
                // Vérifier si le personnel appartient au département sélectionné
                personnelDepartementCoherent = verifierPersonnelDansDepartementParId(personnelId, departement);
            }

            List<Pointage> pointagesFiltres = new ArrayList<>();
            Map<String, Object> statistiques = new HashMap<>();
            Map<String, List<Map<String, Object>>> statutsPersonnels = new HashMap<>();

            if (personnelDepartementCoherent) {
                // Générer le rapport avec les filtres
                pointagesFiltres = getPointagesFiltres(dateDebut, null, personnelId, departement, periode);



                // Calculer les statistiques
                statistiques = calculerStatistiques(pointagesFiltres);

                // Obtenir les statuts des personnels par département (filtrés si nécessaire)
                statutsPersonnels = getStatutsPersonnelsParDepartement(dateDebut, departement, personnelId);
            } else {
                System.out.println("Personnel et département incohérents - aucun résultat affiché");
                // Ne pas afficher de données du tout
                pointagesFiltres = new ArrayList<>();
                statistiques = new HashMap<>();
                statutsPersonnels = new HashMap<>();
            }

            request.setAttribute("pointages", pointagesFiltres);
            request.setAttribute("statistiques", statistiques);
            request.setAttribute("statutsPersonnels", statutsPersonnels);
            request.setAttribute("dateDebut", dateDebut);
            request.setAttribute("personnelId", personnelId);
            request.setAttribute("departement", departement);
            request.setAttribute("periode", periode);
        } else {
            // Page par défaut - initialiser avec des valeurs vides
            request.setAttribute("pointages", new ArrayList<Pointage>());
            request.setAttribute("statutsPersonnels", new HashMap<String, List<Map<String, Object>>>());
            request.setAttribute("dateDebut", "");
            request.setAttribute("personnelId", "tous");
            request.setAttribute("departement", "tous");
        }
        
        // Toujours passer ces attributs
        request.setAttribute("tousPersonnels", tousPersonnels);
        request.setAttribute("tousDepartements", tousDepartements);
        
        // DEBUG
        System.out.println("Tous personnels: " + (tousPersonnels != null ? tousPersonnels.size() : 0));
        System.out.println("Tous départements: " + (tousDepartements != null ? tousDepartements.size() : 0));
        
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
                // Vérifier si c'est un ID numérique ou un nom complet
                try {
                    int personnelIdInt = Integer.parseInt(personnelId);
                    ps.setInt(paramIndex++, personnelIdInt);
                } catch (NumberFormatException e) {
                    // Si ce n'est pas un ID numérique, rechercher par nom complet
                    // Pour cela, on doit modifier la requête SQL pour utiliser CONCAT
                    // Mais pour simplifier, on peut rechercher l'ID par nom d'abord
                    int personnelIdFromName = getPersonnelIdByNom(personnelId);
                    if (personnelIdFromName > 0) {
                        ps.setInt(paramIndex++, personnelIdFromName);
                    } else {
                        // Si pas trouvé, ne pas appliquer le filtre
                        // On pourrait annuler la requête, mais pour simplifier, on continue sans ce paramètre
                    }
                }
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
            System.err.println("Erreur dans getPointagesFiltres: " + e.getMessage());
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
            System.err.println("Erreur dans getAllPersonnel: " + e.getMessage());
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
            System.err.println("Erreur dans getAllDepartements: " + e.getMessage());
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
        
        for (Pointage pt : pointages) {
            if ("entree".equalsIgnoreCase(pt.getType())) {
                entrees++;
            } else if ("sortie".equalsIgnoreCase(pt.getType())) {
                sorties++;
            }
            
            String nomComplet = pt.getNomPersonnel() + " " + pt.getPrenomPersonnel();
            pointagesParPersonnel.put(nomComplet, pointagesParPersonnel.getOrDefault(nomComplet, 0) + 1);
        }
        
        stats.put("totalPointages", totalPointages);
        stats.put("entrees", entrees);
        stats.put("sorties", sorties);
        stats.put("pointagesParPersonnel", pointagesParPersonnel);
        
        return stats;
    }

    private Map<String, List<Map<String, Object>>> getStatutsPersonnelsParDepartement(String dateStr, String departementFiltre, String personnelIdFiltre) {
        Map<String, List<Map<String, Object>>> result = new HashMap<>();

        try (Connection conn = Database.getConnection()) {
            // Récupérer tous les personnels avec leurs départements (filtrés si nécessaire)
            StringBuilder sql = new StringBuilder("SELECT id, nom, prenom, numero_employe, departement FROM personnel WHERE 1=1");

            // Appliquer le filtre de département si spécifié
            if (departementFiltre != null && !departementFiltre.isEmpty() && !"tous".equals(departementFiltre)) {
                sql.append(" AND departement = ?");
            }

            // Appliquer le filtre de personnel si spécifié
            if (personnelIdFiltre != null && !personnelIdFiltre.isEmpty() && !"tous".equals(personnelIdFiltre)) {
                try {
                    int personnelIdInt = Integer.parseInt(personnelIdFiltre);
                    sql.append(" AND id = ?");
                } catch (NumberFormatException e) {
                    // Si ce n'est pas un ID numérique, rechercher par nom complet
                    int personnelIdFromName = getPersonnelIdByNom(personnelIdFiltre);
                    if (personnelIdFromName > 0) {
                        sql.append(" AND id = ?");
                    }
                }
            }

            sql.append(" ORDER BY departement, nom, prenom");

            PreparedStatement ps = conn.prepareStatement(sql.toString());

            int paramIndex = 1;

            // Paramètre pour le filtre de département
            if (departementFiltre != null && !departementFiltre.isEmpty() && !"tous".equals(departementFiltre)) {
                ps.setString(paramIndex++, departementFiltre);
            }

            // Paramètre pour le filtre de personnel
            if (personnelIdFiltre != null && !personnelIdFiltre.isEmpty() && !"tous".equals(personnelIdFiltre)) {
                try {
                    int personnelIdInt = Integer.parseInt(personnelIdFiltre);
                    ps.setInt(paramIndex++, personnelIdInt);
                } catch (NumberFormatException e) {
                    // Si ce n'est pas un ID numérique, rechercher par nom complet
                    int personnelIdFromName = getPersonnelIdByNom(personnelIdFiltre);
                    if (personnelIdFromName > 0) {
                        ps.setInt(paramIndex++, personnelIdFromName);
                    }
                }
            }

            ResultSet rs = ps.executeQuery();
            
            // Convertir la date sélectionnée en Date
            java.sql.Date selectedDate = null;
            if (dateStr != null && !dateStr.isEmpty()) {
                try {
                    selectedDate = java.sql.Date.valueOf(dateStr);
                } catch (IllegalArgumentException e) {
                    System.err.println("Format de date invalide: " + dateStr);
                    selectedDate = null;
                }
            }
            
            while (rs.next()) {
                int personnelId = rs.getInt("id");
                String nom = rs.getString("nom");
                String prenom = rs.getString("prenom");
                String numeroEmploye = rs.getString("numero_employe");
                String departement = rs.getString("departement");
                
                if (departement == null || departement.isEmpty()) {
                    departement = "Non spécifié";
                }
                
                // Déterminer le statut du personnel pour la date sélectionnée
                String statut = "Absent";
                
                // Si une date est sélectionnée, vérifier les pointages
                if (selectedDate != null) {
                    String sqlPointage = "SELECT COUNT(*) as count FROM pointage WHERE personnel_id = ? AND DATE(date_pointage) = ? AND type = 'entree'";
                    PreparedStatement psPointage = conn.prepareStatement(sqlPointage);
                    psPointage.setInt(1, personnelId);
                    psPointage.setDate(2, selectedDate);
                    
                    ResultSet rsPointage = psPointage.executeQuery();
                    if (rsPointage.next() && rsPointage.getInt("count") > 0) {
                        statut = "Présent";
                    }
                    
                    rsPointage.close();
                    psPointage.close();
                }
                
                Map<String, Object> personnelInfo = new HashMap<>();
                personnelInfo.put("id", personnelId);
                personnelInfo.put("nom", nom);
                personnelInfo.put("prenom", prenom);
                personnelInfo.put("matricule", numeroEmploye);
                personnelInfo.put("statut", statut);
                
                if (!result.containsKey(departement)) {
                    result.put(departement, new ArrayList<>());
                }
                result.get(departement).add(personnelInfo);
            }
            
            rs.close();
            ps.close();
            
        } catch (Exception e) {
            System.err.println("Erreur dans getStatutsPersonnelsParDepartement: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }

    private boolean verifierPersonnelDansDepartementParId(String personnelId, String departement) {
        boolean appartient = false;

        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT COUNT(*) as count FROM personnel WHERE id = ? AND departement = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(personnelId));
            ps.setString(2, departement);

            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt("count") > 0) {
                appartient = true;
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            System.err.println("Erreur dans verifierPersonnelDansDepartementParId: " + e.getMessage());
            e.printStackTrace();
        }

        return appartient;
    }

    private boolean verifierPersonnelDansDepartementParNom(String personnelNom, String departement) {
        boolean appartient = false;

        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT COUNT(*) as count FROM personnel WHERE CONCAT(nom, ' ', prenom) = ? AND departement = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, personnelNom);
            ps.setString(2, departement);

            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt("count") > 0) {
                appartient = true;
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            System.err.println("Erreur dans verifierPersonnelDansDepartementParNom: " + e.getMessage());
            e.printStackTrace();
        }

        return appartient;
    }

    private int getPersonnelIdByNom(String nomComplet) {
        int id = -1;

        try (Connection conn = Database.getConnection()) {
            String sql = "SELECT id FROM personnel WHERE CONCAT(nom, ' ', prenom) = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nomComplet);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                id = rs.getInt("id");
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            System.err.println("Erreur dans getPersonnelIdByNom: " + e.getMessage());
            e.printStackTrace();
        }

        return id;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

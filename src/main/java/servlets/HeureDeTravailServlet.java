package servlets;

import utils.Database;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.time.DayOfWeek;
import java.util.Locale;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/HeureDeTravailServlet")
public class HeureDeTravailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static class HeureDeTravail {
        private String nomComplet;
        private Date dateTravail;
        private String heures; // Utilisé pour afficher les heures selon le contexte

        public HeureDeTravail(String nomComplet, Date dateTravail, String heures) {
            this.nomComplet = nomComplet;
            this.dateTravail = dateTravail;
            this.heures = heures;
        }

        public String getNomComplet() { return nomComplet; }
        public Date getDateTravail() { return dateTravail; }
        public String getHeures() { return heures; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<HeureDeTravail> heuresJour = new ArrayList<>();
        List<HeureDeTravail> heuresSemaine = new ArrayList<>();
        List<HeureDeTravail> heuresMois = new ArrayList<>();

        String action = request.getParameter("action");  // filterSemaine ou filterMois
        String weekParamSelected = request.getParameter("week");
        String monthParamSelected = request.getParameter("month");

        // Onglet actif par défaut
        String activeTab = "jour";

        try (Connection conn = Database.getConnection()) {
            
            // ----------- HEURES PAR JOUR -----------
            String sqlJour = """
                SELECT per.id, per.nom, per.prenom, DATE(ent.date_pointage) AS jour,
                       CONCAT(FLOOR(SUM(TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)) / 60), 'h ',
                              LPAD(MOD(SUM(TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)), 60), 2, '0'), 'min') AS heures_jour
                FROM pointage ent
                JOIN pointage sor ON sor.personnel_id = ent.personnel_id
                                 AND sor.type = 'sortie'
                                 AND ent.type = 'entree'
                                 AND DATE(ent.date_pointage) = DATE(sor.date_pointage)
                                 AND sor.date_pointage > ent.date_pointage
                JOIN personnel per ON per.id = ent.personnel_id
                GROUP BY per.id, per.nom, per.prenom, DATE(ent.date_pointage)
                ORDER BY per.nom, per.prenom, jour DESC;
            """;

            try (PreparedStatement stmtJour = conn.prepareStatement(sqlJour);
                 ResultSet rsJour = stmtJour.executeQuery()) {
                
                while (rsJour.next()) {
                    String nomComplet = rsJour.getString("nom") + " " + rsJour.getString("prenom");
                    Date dateTravail = rsJour.getDate("jour");
                    String heuresJour_str = rsJour.getString("heures_jour");
                    
                    heuresJour.add(new HeureDeTravail(nomComplet, dateTravail, heuresJour_str));
                }
            }

            // ----------- HEURES PAR SEMAINE -----------
            String sqlSemaine = """
                SELECT per.id, per.nom, per.prenom, 
                       YEAR(e.date_pointage) AS annee, 
                       WEEK(e.date_pointage, 1) AS semaine_num,
                       MIN(DATE(e.date_pointage)) AS debut_semaine,
                       MAX(DATE(e.date_pointage)) AS fin_semaine,
                       CONCAT(FLOOR(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)) / 60), 'h ',
                              LPAD(MOD(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)), 60), 2, '0'), 'min') AS heures_semaine
                FROM pointage e
                JOIN pointage s ON s.personnel_id = e.personnel_id
                                AND s.type = 'sortie'
                                AND e.type = 'entree'
                                AND DATE(e.date_pointage) = DATE(s.date_pointage)
                                AND s.date_pointage > e.date_pointage
                JOIN personnel per ON per.id = e.personnel_id
                GROUP BY per.id, per.nom, per.prenom, annee, semaine_num
                HAVING 1=1
            """;

            if ("filterSemaine".equals(action) && weekParamSelected != null) {
                sqlSemaine += " AND semaine_num = ? ";
                activeTab = "semaine"; // rester sur l’onglet semaine
            }
            sqlSemaine += " ORDER BY per.nom, per.prenom, annee DESC, semaine_num DESC";

            try (PreparedStatement stmtSemaine = conn.prepareStatement(sqlSemaine)) {
                if ("filterSemaine".equals(action) && weekParamSelected != null) {
                    stmtSemaine.setInt(1, Integer.parseInt(weekParamSelected));
                }
                try (ResultSet rsSemaine = stmtSemaine.executeQuery()) {
                    while (rsSemaine.next()) {
                        String nomComplet = rsSemaine.getString("nom") + " " + rsSemaine.getString("prenom");
                        Date debutSemaine = rsSemaine.getDate("debut_semaine");
                        Date finSemaine = rsSemaine.getDate("fin_semaine");
                        String heures = rsSemaine.getString("heures_semaine");

                        LocalDate debut = debutSemaine.toLocalDate();
                        LocalDate lundi = debut.with(DayOfWeek.MONDAY);
                        LocalDate dimanche = debut.with(DayOfWeek.SUNDAY);

                        String periodeTexte = lundi.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) +
                                              " au " +
                                              dimanche.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));

                        heuresSemaine.add(new HeureDeTravail(nomComplet + " (" + periodeTexte + ")", debutSemaine, heures));
                    }
                }
            }

            // ----------- HEURES PAR MOIS -----------
            String sqlMois = """
                SELECT per.id, per.nom, per.prenom, 
                       YEAR(e.date_pointage) AS annee, 
                       MONTH(e.date_pointage) AS mois_num,
                       CONCAT(FLOOR(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)) / 60), 'h ',
                              LPAD(MOD(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)), 60), 2, '0'), 'min') AS heures_mois
                FROM pointage e
                JOIN pointage s ON s.personnel_id = e.personnel_id
                                AND s.type = 'sortie'
                                AND e.type = 'entree'
                                AND DATE(e.date_pointage) = DATE(s.date_pointage)
                                AND s.date_pointage > e.date_pointage
                JOIN personnel per ON per.id = e.personnel_id
                GROUP BY per.id, per.nom, per.prenom, annee, mois_num
                HAVING 1=1
            """;

            if ("filterMois".equals(action) && monthParamSelected != null) {
                sqlMois += " AND mois_num = ? ";
                activeTab = "mois"; // rester sur l’onglet mois
            }
            sqlMois += " ORDER BY per.nom, per.prenom, annee DESC, mois_num DESC";

            try (PreparedStatement stmtMois = conn.prepareStatement(sqlMois)) {
                if ("filterMois".equals(action) && monthParamSelected != null) {
                    stmtMois.setInt(1, Integer.parseInt(monthParamSelected));
                }
                try (ResultSet rsMois = stmtMois.executeQuery()) {
                    while (rsMois.next()) {
                        String nomComplet = rsMois.getString("nom") + " " + rsMois.getString("prenom");
                        int annee = rsMois.getInt("annee");
                        int moisNum = rsMois.getInt("mois_num");
                        String heures = rsMois.getString("heures_mois");

                        Date dateMois = Date.valueOf(LocalDate.of(annee, moisNum, 1));

                        heuresMois.add(new HeureDeTravail(nomComplet + " (" + convertirNumeroMoisEnFrancais(moisNum) + ")", dateMois, heures));
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Passer les listes + onglet actif à la JSP
        request.setAttribute("heuresJour", heuresJour);
        request.setAttribute("heuresSemaine", heuresSemaine);
        request.setAttribute("heuresMois", heuresMois);
        request.setAttribute("activeTab", activeTab);

        request.getRequestDispatcher("heures_travail.jsp").forward(request, response);
    }
    
    private String convertirNumeroMoisEnFrancais(int moisNum) {
        switch (moisNum) {
            case 1: return "JANVIER";
            case 2: return "FÉVRIER";
            case 3: return "MARS";
            case 4: return "AVRIL";
            case 5: return "MAI";
            case 6: return "JUIN";
            case 7: return "JUILLET";
            case 8: return "AOÛT";
            case 9: return "SEPTEMBRE";
            case 10: return "OCTOBRE";
            case 11: return "NOVEMBRE";
            case 12: return "DÉCEMBRE";
            default: return "MOIS " + moisNum;
        }
    }
}

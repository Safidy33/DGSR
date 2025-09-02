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

@WebServlet("/HeureDeTravailServlet")
public class HeureDeTravailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static class HeureDeTravail {
        private String nomComplet;
        private Date dateTravail;
        private String heuresJour;
        private String heuresSemaine;
        private String heuresMois;

        public HeureDeTravail(String nomComplet, Date dateTravail,
                              String heuresJour, String heuresSemaine, String heuresMois) {
            this.nomComplet = nomComplet;
            this.dateTravail = dateTravail;
            this.heuresJour = heuresJour;
            this.heuresSemaine = heuresSemaine;
            this.heuresMois = heuresMois;
        }

        public String getNomComplet() { return nomComplet; }
        public Date getDateTravail() { return dateTravail; }
        public String getHeuresJour() { return heuresJour; }
        public String getHeuresSemaine() { return heuresSemaine; }
        public String getHeuresMois() { return heuresMois; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<HeureDeTravail> heuresTravail = new ArrayList<>();

        // Requête principale : heures journalières
        String sqlJour = """
            SELECT per.id, per.nom, per.prenom, DATE(ent.date_pointage) AS jour,
                   CONCAT(FLOOR(SUM(TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)) / 60), 'h ',
                          LPAD(MOD(SUM(TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)), 60), 2, '0'), 'min') AS heures_jour
            FROM pointage ent
            JOIN pointage sor ON sor.personnel_id = ent.personnel_id
                             AND sor.type = 'sortie'
                             AND ent.type = 'entree'
                             AND DATE(ent.date_pointage) = DATE(sor.date_pointage)
            JOIN personnel per ON per.id = ent.personnel_id
            GROUP BY per.id, per.nom, per.prenom, DATE(ent.date_pointage)
            ORDER BY per.nom, per.prenom, jour;
        """;

        try (Connection conn = Database.getConnection();
             PreparedStatement stmtJour = conn.prepareStatement(sqlJour)) {

            ResultSet rs = stmtJour.executeQuery();
            while (rs.next()) {
                int personnelId = rs.getInt("id");
                String nomComplet = rs.getString("nom") + " " + rs.getString("prenom");
                Date dateTravail = rs.getDate("jour");
                String heuresJour = rs.getString("heures_jour");

                // ✅ Calcul heures semaine
                String sqlSemaine = """
                    SELECT CONCAT(FLOOR(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)) / 60), 'h ',
                                  LPAD(MOD(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)), 60), 2, '0'), 'min') AS total
                    FROM pointage e
                    JOIN pointage s ON s.personnel_id = e.personnel_id
                                    AND s.type = 'sortie'
                                    AND e.type = 'entree'
                                    AND DATE(e.date_pointage) = DATE(s.date_pointage)
                    WHERE e.personnel_id = ?
                      AND YEARWEEK(e.date_pointage, 1) = YEARWEEK(?, 1);
                """;
                PreparedStatement stmtSemaine = conn.prepareStatement(sqlSemaine);
                stmtSemaine.setInt(1, personnelId);
                stmtSemaine.setDate(2, dateTravail);
                ResultSet rsSemaine = stmtSemaine.executeQuery();
                String heuresSemaine = rsSemaine.next() ? rsSemaine.getString("total") : "0h00min";
                rsSemaine.close();
                stmtSemaine.close();

                // ✅ Calcul heures mois
                String sqlMois = """
                    SELECT CONCAT(FLOOR(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)) / 60), 'h ',
                                  LPAD(MOD(SUM(TIMESTAMPDIFF(MINUTE, e.date_pointage, s.date_pointage)), 60), 2, '0'), 'min') AS total
                    FROM pointage e
                    JOIN pointage s ON s.personnel_id = e.personnel_id
                                    AND s.type = 'sortie'
                                    AND e.type = 'entree'
                                    AND DATE(e.date_pointage) = DATE(s.date_pointage)
                    WHERE e.personnel_id = ?
                      AND YEAR(e.date_pointage) = YEAR(?)
                      AND MONTH(e.date_pointage) = MONTH(?);
                """;
                PreparedStatement stmtMois = conn.prepareStatement(sqlMois);
                stmtMois.setInt(1, personnelId);
                stmtMois.setDate(2, dateTravail);
                stmtMois.setDate(3, dateTravail);
                ResultSet rsMois = stmtMois.executeQuery();
                String heuresMois = rsMois.next() ? rsMois.getString("total") : "0h00min";
                rsMois.close();
                stmtMois.close();

                // Ajout dans la liste
                heuresTravail.add(new HeureDeTravail(nomComplet, dateTravail, heuresJour, heuresSemaine, heuresMois));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("heuresTravail", heuresTravail);
        request.getRequestDispatcher("heures_travail.jsp").forward(request, response);
    }
}

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

        // ✅ SQL corrigé : formatage heures + minutes (lundi à vendredi)
        String sql = """
SELECT 
    per.nom,
    per.prenom,
    ent.personnel_id,
    DATE(ent.date_pointage) AS jour,

    -- Heures jour
    CONCAT(
       FLOOR(SUM(CASE 
           WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
           THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
           ELSE 0 END) / 60), 'h ',
       LPAD(MOD(SUM(CASE 
           WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
           THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
           ELSE 0 END), 60), 2, '0'), 'min'
    ) AS heures_jour,

    -- Heures semaine
    CONCAT(
       FLOOR(SUM(CASE 
           WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
            AND YEARWEEK(ent.date_pointage, 1) = YEARWEEK(CURDATE(), 1)
           THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
           ELSE 0 END) / 60), 'h ',
       LPAD(MOD(SUM(CASE 
           WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
            AND YEARWEEK(ent.date_pointage, 1) = YEARWEEK(CURDATE(), 1)
           THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
           ELSE 0 END), 60), 2, '0'), 'min'
    ) AS heures_semaine,

    -- Heures mois
    CONCAT(
       FLOOR(SUM(CASE 
           WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
            AND YEAR(ent.date_pointage) = YEAR(CURDATE())
            AND MONTH(ent.date_pointage) = MONTH(CURDATE())
           THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
           ELSE 0 END) / 60), 'h ',
       LPAD(MOD(SUM(CASE 
           WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
            AND YEAR(ent.date_pointage) = YEAR(CURDATE())
            AND MONTH(ent.date_pointage) = MONTH(CURDATE())
           THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
           ELSE 0 END), 60), 2, '0'), 'min'
    ) AS heures_mois

FROM pointage ent
LEFT JOIN pointage sor 
  ON sor.personnel_id = ent.personnel_id
 AND sor.type = 'sortie'
 AND ent.type = 'entree'
 AND DATE(ent.date_pointage) = DATE(sor.date_pointage)
JOIN personnel per ON per.id = ent.personnel_id
GROUP BY per.id, per.nom, per.prenom, ent.personnel_id, DATE(ent.date_pointage)
ORDER BY per.nom, per.prenom, jour;
        """;

        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String nomComplet = rs.getString("nom") + " " + rs.getString("prenom");
                Date dateTravail = rs.getDate("jour");
                String heuresJour = rs.getString("heures_jour");
                String heuresSemaine = rs.getString("heures_semaine");
                String heuresMois = rs.getString("heures_mois");

                heuresTravail.add(new HeureDeTravail(nomComplet, dateTravail, heuresJour, heuresSemaine, heuresMois));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("heuresTravail", heuresTravail);
        request.getRequestDispatcher("heures_travail.jsp").forward(request, response);
    }
}

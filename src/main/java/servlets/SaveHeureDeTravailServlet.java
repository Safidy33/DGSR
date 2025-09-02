package servlets;

import utils.Database;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SaveHeureDeTravailServlet")
public class SaveHeureDeTravailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ✅ Servlet qui calcule et insère dans la table heuredetravail
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sql = """
            SELECT 
                per.id AS personnel_id,
                DATE(ent.date_pointage) AS jour,
                SUM(CASE 
                    WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
                    THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
                    ELSE 0 END) AS minutes_jour,

                SUM(CASE 
                    WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
                     AND YEARWEEK(ent.date_pointage, 1) = YEARWEEK(CURDATE(), 1)
                    THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
                    ELSE 0 END) AS minutes_semaine,

                SUM(CASE 
                    WHEN DAYOFWEEK(ent.date_pointage) BETWEEN 2 AND 6
                     AND YEAR(ent.date_pointage) = YEAR(CURDATE())
                     AND MONTH(ent.date_pointage) = MONTH(CURDATE())
                    THEN TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage)
                    ELSE 0 END) AS minutes_mois

            FROM pointage ent
            LEFT JOIN pointage sor 
              ON sor.personnel_id = ent.personnel_id
             AND sor.type = 'sortie'
             AND ent.type = 'entree'
             AND DATE(ent.date_pointage) = DATE(sor.date_pointage)
            JOIN personnel per ON per.id = ent.personnel_id
            GROUP BY per.id, DATE(ent.date_pointage)
            ORDER BY per.nom, per.prenom, jour;
        """;

        String insertSql = """
            INSERT INTO heuredetravail (personnel_id, date_travail, heures_jour, heures_semaine, heures_mois)
            VALUES (?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE 
                heures_jour = VALUES(heures_jour),
                heures_semaine = VALUES(heures_semaine),
                heures_mois = VALUES(heures_mois);
        """;

        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            PreparedStatement insertStmt = conn.prepareStatement(insertSql);

            while (rs.next()) {
                int personnelId = rs.getInt("personnel_id");
                Date dateTravail = rs.getDate("jour");

                // Conversion minutes -> heures (double)
                double heuresJour = rs.getInt("minutes_jour") / 60.0;
                double heuresSemaine = rs.getInt("minutes_semaine") / 60.0;
                double heuresMois = rs.getInt("minutes_mois") / 60.0;

                insertStmt.setInt(1, personnelId);
                insertStmt.setDate(2, dateTravail);
                insertStmt.setDouble(3, heuresJour);
                insertStmt.setDouble(4, heuresSemaine);
                insertStmt.setDouble(5, heuresMois);

                insertStmt.executeUpdate();
            }

            insertStmt.close();

            response.getWriter().println("✅ Données insérées/mises à jour dans la table heuredetravail avec succès.");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Erreur : " + e.getMessage());
        }
    }
}

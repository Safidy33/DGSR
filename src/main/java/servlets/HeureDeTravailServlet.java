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
        private double heuresJour;
        private double heuresSemaine;
        private double heuresMois;

        public HeureDeTravail(String nomComplet, Date dateTravail, double heuresJour, double heuresSemaine, double heuresMois) {
            this.nomComplet = nomComplet;
            this.dateTravail = dateTravail;
            this.heuresJour = heuresJour;
            this.heuresSemaine = heuresSemaine;
            this.heuresMois = heuresMois;
        }

        public String getNomComplet() { return nomComplet; }
        public Date getDateTravail() { return dateTravail; }
        public double getHeuresJour() { return heuresJour; }
        public double getHeuresSemaine() { return heuresSemaine; }
        public double getHeuresMois() { return heuresMois; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<HeureDeTravail> heuresTravail = new ArrayList<>();

        String sql = """
           SELECT 
    per.nom,
    per.prenom,
    DATE(ent.date_pointage) AS jour,
    IFNULL(SUM(TIMESTAMPDIFF(MINUTE, ent.date_pointage, sor.date_pointage))/60, 0) AS heures_jour
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

        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                String nomComplet = rs.getString("nom") + " " + rs.getString("prenom");
                Date dateTravail = rs.getDate("jour");
                double heuresJour = rs.getDouble("heures_jour");
                double heuresSemaine = rs.getDouble("heures_semaine");
                double heuresMois = rs.getDouble("heures_mois");

                heuresTravail.add(new HeureDeTravail(nomComplet, dateTravail, heuresJour, heuresSemaine, heuresMois));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("heuresTravail", heuresTravail);
        request.getRequestDispatcher("heures_travail.jsp").forward(request, response);
    }
}

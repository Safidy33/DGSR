package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import models.Personnel;
import models.Pointage;
import utils.Database;

@WebServlet("/VoirAbsencesServlet")
public class VoirAbsencesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public VoirAbsencesServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Pointage> absencesList = new ArrayList<>();
        List<Personnel> personnelList = new ArrayList<>();
        
        try (Connection conn = Database.getConnection()) {
            // Récupérer la liste du personnel
            String personnelQuery = "SELECT id, nom, prenom FROM personnel ORDER BY nom, prenom";
            try (PreparedStatement stmt = conn.prepareStatement(personnelQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Personnel personnel = new Personnel();
                    personnel.setId(rs.getInt("id"));
                    personnel.setNom(rs.getString("nom"));
                    personnel.setPrenom(rs.getString("prenom"));
                    personnelList.add(personnel);
                }
            }
            
            // Récupérer les absences avec filtres
            StringBuilder absenceQuery = new StringBuilder(
                "SELECT pt.id, p.nom, p.prenom, pt.date_pointage, pt.type_pointage, pt.statut, pt.motif\n"
                + "" +
                "FROM personnel p " +
                "JOIN pointage pt ON p.id = pt.personnel_id " +
                "WHERE pt.type_pointage = 'ABSENT' "
            );
            
            List<Object> params = new ArrayList<>();
            
            // Ajouter les filtres
            String dateDebut = request.getParameter("dateDebut");
            String dateFin = request.getParameter("dateFin");
            String personnelId = request.getParameter("personnel");
            
            if (dateDebut != null && !dateDebut.isEmpty()) {
                absenceQuery.append("AND pt.date_pointage >= ? ");
                params.add(dateDebut);
            }
            
            if (dateFin != null && !dateFin.isEmpty()) {
                absenceQuery.append("AND pt.date_pointage <= ? ");
                params.add(dateFin);
            }
            
            if (personnelId != null && !personnelId.isEmpty()) {
                absenceQuery.append("AND p.id = ? ");
                params.add(Integer.parseInt(personnelId));
            }
            
            absenceQuery.append("ORDER BY pt.date_pointage DESC");
            
            try (PreparedStatement stmt = conn.prepareStatement(absenceQuery.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    stmt.setObject(i + 1, params.get(i));
                }
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Pointage pointage = new Pointage();
                        pointage.setId(rs.getInt("id"));
                        pointage.setDate(rs.getDate("date_pointage"));
                        pointage.setType(rs.getString("type_pointage"));
                        pointage.setMotif(rs.getString("motif"));
                        pointage.setStatut(rs.getString("statut"));
                        
                        Personnel personnel = new Personnel();
                        personnel.setNom(rs.getString("nom"));
                        personnel.setPrenom(rs.getString("prenom"));
                        pointage.setNomPersonnel(personnel);
                        
                        absencesList.add(pointage);
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des absences: " + e.getMessage());
        }
        
        request.setAttribute("absencesList", absencesList);
        request.setAttribute("personnelList", personnelList);
        request.getRequestDispatcher("/voir_absences.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

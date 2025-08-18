package servlets;

import models.Personnel;
import utils.Database;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/gerer-personnel")
public class GererPersonnelServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérifier si l'utilisateur est connecté
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            // Récupérer la liste des personnels
            List<Personnel> personnels = getAllPersonnels();
            
            // Transmettre la liste à la JSP
            request.setAttribute("personnels", personnels);
            
            // Rediriger vers la page JSP
            request.getRequestDispatcher("/gerer_personnel.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des personnels : " + e.getMessage());
            request.getRequestDispatcher("/gerer_personnel.jsp").forward(request, response);
        }
    }

    private List<Personnel> getAllPersonnels() throws Exception {
        List<Personnel> personnels = new ArrayList<>();
        
        String sql = "SELECT id, nom, prenom, numero_employe, departement, Email, qr_code FROM personnel ORDER BY nom, prenom";
        
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Personnel personnel = new Personnel();
                personnel.setId(rs.getInt("id"));
                personnel.setNom(rs.getString("nom"));
                personnel.setPrenom(rs.getString("prenom"));
                personnel.setNumeroEmploye(rs.getString("numero_employe"));
                personnel.setDepartement(rs.getString("departement"));
                personnel.setEmail(rs.getString("Email"));
                personnel.setQrCode(rs.getString("qr_code"));
                
                personnels.add(personnel);
            }
        }
        
        return personnels;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Pour les opérations CRUD (ajouter, modifier, supprimer)
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addPersonnel(request);
                    break;
                case "update":
                    updatePersonnel(request);
                    break;
                case "delete":
                    deletePersonnel(request);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de l'opération : " + e.getMessage());
        }
        
        // Recharger la page
        doGet(request, response);
    }

    private void addPersonnel(HttpServletRequest request) throws Exception {
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String numeroEmploye = request.getParameter("numeroEmploye");
        String departement = request.getParameter("departement");
        String email = request.getParameter("email");
        
        String sql = "INSERT INTO personnel (nom, prenom, numero_employe, departement, Email) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nom);
            stmt.setString(2, prenom);
            stmt.setString(3, numeroEmploye);
            stmt.setString(4, departement);
            stmt.setString(5, email);
            
            stmt.executeUpdate();
        }
    }

    private void updatePersonnel(HttpServletRequest request) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String numeroEmploye = request.getParameter("numeroEmploye");
        String departement = request.getParameter("departement");
        String email = request.getParameter("email");
        
        String sql = "UPDATE personnel SET nom = ?, prenom = ?, numero_employe = ?, departement = ?, Email = ? WHERE id = ?";
        
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nom);
            stmt.setString(2, prenom);
            stmt.setString(3, numeroEmploye);
            stmt.setString(4, departement);
            stmt.setString(5, email);
            stmt.setInt(6, id);
            
            stmt.executeUpdate();
        }
    }

    private void deletePersonnel(HttpServletRequest request) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        
        String sql = "DELETE FROM personnel WHERE id = ?";
        
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}

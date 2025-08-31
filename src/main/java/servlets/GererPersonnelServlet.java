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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("edit".equals(action)) {
                handleEdit(request, response);
                return;
            } else if ("delete".equals(action)) {
                handleDelete(request, response);
                return;
            }
            
            String searchTerm = request.getParameter("search");
            String departement = request.getParameter("departement");

            List<Personnel> personnels = getPersonnels(searchTerm, departement);

            request.setAttribute("personnels", personnels);
            request.getRequestDispatcher("/gerer_personnel.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de l'opération : " + e.getMessage());
            request.getRequestDispatcher("/gerer_personnel.jsp").forward(request, response);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Personnel personnel = getPersonnelById(id);
        request.setAttribute("personnel", personnel);
        request.getRequestDispatcher("/modifier_personnel.jsp").forward(request, response);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        deletePersonnel(request);
        response.sendRedirect("gerer-personnel");
    }

    private Personnel getPersonnelById(int id) throws Exception {
        String sql = "SELECT id, nom, prenom, numero_employe, departement, Email, qr_code FROM personnel WHERE id = ?";
        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Personnel p = new Personnel();
                    p.setId(rs.getInt("id"));
                    p.setNom(rs.getString("nom"));
                    p.setPrenom(rs.getString("prenom"));
                    p.setNumeroEmploye(rs.getString("numero_employe"));
                    p.setDepartement(rs.getString("departement"));
                    p.setEmail(rs.getString("Email"));
                    p.setQrCode(rs.getString("qr_code"));
                    return p;
                }
            }
        }
        return null;
    }

    private List<Personnel> getPersonnels(String searchTerm, String departement) throws Exception {
        List<Personnel> personnels = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT id, nom, prenom, numero_employe, departement, Email, qr_code " +
            "FROM personnel WHERE 1=1"
        );

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            // Recherche nom, prénom, email, numéro de téléphone ou nom complet
            sql.append(" AND (nom LIKE ? OR prenom LIKE ? OR Email LIKE ? OR numero_employe LIKE ? OR CONCAT(nom,' ',prenom) LIKE ?)");
        }

        if (departement != null && !departement.trim().isEmpty()) {
            sql.append(" AND departement = ?");
        }

        sql.append(" ORDER BY nom, prenom");

        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String likeTerm = "%" + searchTerm + "%";
                stmt.setString(paramIndex++, likeTerm); // nom
                stmt.setString(paramIndex++, likeTerm); // prenom
                stmt.setString(paramIndex++, likeTerm); // email
                stmt.setString(paramIndex++, likeTerm); // numero_employe
                stmt.setString(paramIndex++, likeTerm); // nom complet
            }

            if (departement != null && !departement.trim().isEmpty()) {
                stmt.setString(paramIndex++, departement);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Personnel p = new Personnel();
                    p.setId(rs.getInt("id"));
                    p.setNom(rs.getString("nom"));
                    p.setPrenom(rs.getString("prenom"));
                    p.setNumeroEmploye(rs.getString("numero_employe"));
                    p.setDepartement(rs.getString("departement"));
                    p.setEmail(rs.getString("Email"));
                    p.setQrCode(rs.getString("qr_code"));
                    personnels.add(p);
                }
            }
        }

        return personnels;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ensure UTF-8 encoding for proper display of accented characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    addPersonnel(request);
                    response.sendRedirect("gerer-personnel?success=Personnel ajouté avec succès");
                    return;
                case "update":
                    updatePersonnel(request);
                    response.sendRedirect("gerer-personnel?success=Personnel modifié avec succès");
                    return;
                case "delete":
                    deletePersonnel(request);
                    response.sendRedirect("gerer-personnel?success=Personnel supprimé avec succès");
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("gerer-personnel?error=Erreur lors de l'opération : " + e.getMessage());
            return;
        }

        response.sendRedirect("gerer-personnel");
    }

    private void addPersonnel(HttpServletRequest request) throws Exception {
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String numeroEmploye = request.getParameter("numeroEmploye");
        String departement = request.getParameter("departement");
        String email = request.getParameter("email");
        String qrCode = request.getParameter("qrCode");

        String sql = "INSERT INTO personnel (nom, prenom, numero_employe, departement, Email, qr_code) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nom);
            stmt.setString(2, prenom);
            stmt.setString(3, numeroEmploye);
            stmt.setString(4, departement);
            stmt.setString(5, email);
            stmt.setString(6, qrCode != null && !qrCode.trim().isEmpty() ? qrCode : null);
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
        String qrCode = request.getParameter("qrCode");

        String sql = "UPDATE personnel SET nom = ?, prenom = ?, numero_employe = ?, departement = ?, Email = ?, qr_code = ? WHERE id = ?";

        try (Connection conn = Database.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nom);
            stmt.setString(2, prenom);
            stmt.setString(3, numeroEmploye);
            stmt.setString(4, departement);
            stmt.setString(5, email);
            stmt.setString(6, qrCode != null && !qrCode.trim().isEmpty() ? qrCode : null);
            stmt.setInt(7, id);
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

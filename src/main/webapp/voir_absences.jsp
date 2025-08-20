<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.Personnel, models.Pointage" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Absences - DGSR</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .logo {
            height: 60px;
            width: auto;
        }
        
        h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        
        .breadcrumb {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        
        .content {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .filters {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .filters label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            display: block;
        }
        
        .filters input, .filters select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .filters button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: transform 0.2s;
        }
        
        .filters button:hover {
            transform: translateY(-2px);
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        
        tr:hover {
            background-color: #f8f9fa;
        }
        
        footer {
            text-align: center;
            margin-top: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <img src="assets/img/logo_dgsr.png" alt="Logo DGSR" class="logo">
            <h1>Liste des Absences</h1>
        </header>

        <nav class="breadcrumb">
            <a href="dashboard.jsp">Tableau de bord</a> > 
            <a href="Menu_rapide.jsp">Menu rapide</a> > 
            <span>Absences</span>
        </nav>

        <div class="content">
            <div class="filters">
                <div>
                    <label for="dateDebut">Date début:</label>
                    <input type="date" id="dateDebut" name="dateDebut">
                </div>
                
                <div>
                    <label for="dateFin">Date fin:</label>
                    <input type="date" id="dateFin" name="dateFin">
                </div>
                
                <div>
                    <label for="personnel">Personnel:</label>
                    <select id="personnel" name="personnel">
                        <option value="">Tous</option>
                        <% 
                            // Récupérer la liste du personnel depuis la base de données
                            List<Personnel> personnelList = (List<Personnel>) request.getAttribute("personnelList");
                            if(personnelList != null) {
                                for(Personnel p : personnelList) {
                        %>
                            <option value="<%= p.getId() %>"><%= p.getNom() %> <%= p.getPrenom() %></option>
                        <%      }
                            }
                        %>
                    </select>
                </div>
                
                <div>
                    <button type="button" onclick="filtrerAbsences()">Filtrer</button>
                </div>
            </div>

            <div class="table-container">
                <table id="absencesTable">
                    <thead>
                        <tr>
                            <th>Personnel</th>
                            <th>Date</th>
                            <th>Type</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Pointage> absencesList = (List<Pointage>) request.getAttribute("absencesList");
                            if(absencesList != null && !absencesList.isEmpty()) {
                                for(Pointage absence : absencesList) {
                        %>
                            <tr>
                                <td><%= absence.getNomPersonnel() %> <%= absence.getPrenomPersonnel() %></td>
                                <td><%= absence.getDatePointage() %></td>
                                <td><%= absence.getType() %></td>
                                <td><%= absence.getStatut() %></td>
                            </tr>
                        <%      }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center;">Aucune absence trouvée</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <footer>
            <p>&copy; 2024 DGSR - Direction Générale des Systèmes d'Information</p>
        </footer>
    </div>

    <script>
    function filtrerAbsences() {
        const dateDebut = document.getElementById('dateDebut').value;
        const dateFin = document.getElementById('dateFin').value;
        const personnel = document.getElementById('personnel').value;
        
        const ctx = '<%= request.getContextPath() %>'; // 🔑 récupère le vrai nom du projet
        window.location.href = ctx + '/VoirAbsencesServlet?dateDebut=' + dateDebut + 
                             '&dateFin=' + dateFin + 
                             '&personnel=' + personnel;
    }
</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="models.Personnel" %>
<%
String adminName = "Admin";
if (session != null && session.getAttribute("email") != null) {
    adminName = (String) session.getAttribute("email");
}

List<Personnel> tousPersonnels = (List<Personnel>) request.getAttribute("tousPersonnels");
List<String> tousDepartements = (List<String>) request.getAttribute("tousDepartements");
Map<String, Object> statistiquesGlobales = (Map<String, Object>) request.getAttribute("statistiquesGlobales");
Map<String, Map<String, Object>> statistiquesParDepartement = (Map<String, Map<String, Object>>) request.getAttribute("statistiquesParDepartement");
Map<String, List<Map<String, Object>>> statutsPersonnels = (Map<String, List<Map<String, Object>>>) request.getAttribute("statutsPersonnels");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Statistiques - Système de Gestion de Pointage</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb {
            background-color: #fb5607;
            border-radius: 10px;
            border: 3px solid transparent;
            background-clip: content-box;
        }
        .btn-deconnexion {
            background: linear-gradient(90deg, #ff3e00, #bf2f00);
            transition: background 0.3s ease;
        }
        .btn-deconnexion:hover {
            background: linear-gradient(90deg, #bf2f00, #ff3e00);
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .present {
            background-color: #d1fae5;
            color: #065f46;
            padding: 3px 8px;
            border-radius: 9999px;
            font-weight: 500;
        }

        .absent {
            background-color: #fee2e2;
            color: #991b1b;
            padding: 3px 8px;
            border-radius: 9999px;
            font-weight: 500;
        }

        /* Nouveau style pour le titre principal */
        .main-title {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-size: 2.5rem;
            font-weight: 900;
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
            letter-spacing: -1px;
        }

        .main-title::before {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 120px;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb);
            border-radius: 2px;
        }

        .main-title::after {
            content: '📊';
            position: absolute;
            left: -60px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 2rem;
            filter: drop-shadow(2px 2px 4px rgba(0,0,0,0.2));
        }

        @media (max-width: 768px) {
            .main-title {
                font-size: 2rem;
            }
            .main-title::after {
                left: -50px;
                font-size: 1.5rem;
            }
        }
    </style>
</head>

<body class="bg-gray-50 font-sans text-gray-800 min-h-screen flex flex-col">
    <!-- HEADER -->
    <header class="bg-blue-900 text-white flex items-center justify-between px-6 py-3 select-none">
        <div class="flex items-center space-x-4">
            <button id="btn-toggle-sidebar" aria-label="Toggle menu" class="md:hidden focus:outline-none">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                     class="w-8 h-8 text-white" viewBox="0 0 24 24">
                  <line x1="3" y1="6" x2="21" y2="6"></line>
                  <line x1="3" y1="12" x2="21" y2="12"></line>
                  <line x1="3" y1="18" x2="21" y2="18"></line>
                </svg>
            </button>

            <img src="assets/img/logo_dgsr.png" alt="Logo DGS" class="w-14 h-14 object-cover"/>
            <div class="leading-tight font-semibold max-w-xs">
                <div>Système de Gestion</div>
                <div>de pointage</div>
            </div>
        </div>
        <div class="flex items-center space-x-4">
            <span class="font-semibold"><%= adminName %></span>
            <a href="LogoutServlet" class="btn-deconnexion text-white font-bold px-6 py-2 rounded-xl shadow-lg hover:shadow-2xl transition">Déconnexion</a>
        </div>
    </header>

    <div class="flex flex-1 min-h-0">
        <jsp:include page="Menu_rapide.jsp" />

        <!-- MAIN CONTENT -->
        <main class="flex-1 overflow-auto p-6">
            <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8 mx-auto justify-center">
                <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Tableau de Bord</a>
                <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
                <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
                <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
                <a href="StatistiqueServlet" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Statistiques</a>
                <a href="HeureDeTravailServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
            </nav>

            <h1 class="main-title">Statistiques du Système</h1>

            <!-- Statistiques Globales -->
            <% if (statistiquesGlobales != null) { %>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                <div class="stat-card">
                    <div class="stat-number"><%= statistiquesGlobales.get("totalPointages") %></div>
                    <div class="stat-label">Total Pointages</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= statistiquesGlobales.get("entrees") %></div>
                    <div class="stat-label">Entrées</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= statistiquesGlobales.get("sorties") %></div>
                    <div class="stat-label">Sorties</div>
                </div>
            </div>
            <% } %>

            <!-- Statistiques par Personnel -->
            <% if (statistiquesGlobales != null && statistiquesGlobales.get("pointagesParPersonnel") != null) { %>
            <div class="bg-white rounded-lg shadow p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">👤 Pointages par Personnel</h2>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm text-left text-gray-900">
                        <thead class="text-xs uppercase text-gray-600 bg-gray-200">
                            <tr>
                                <th class="px-4 py-3">Nom du Personnel</th>
                                <th class="px-4 py-3 text-center">Nombre de Pointages</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            @SuppressWarnings("unchecked")
                            Map<String, Integer> pointagesParPersonnel = (Map<String, Integer>) statistiquesGlobales.get("pointagesParPersonnel");
                            for (Map.Entry<String, Integer> entry : pointagesParPersonnel.entrySet()) {
                            %>
                            <tr class="border-b border-gray-200 hover:bg-gray-50">
                                <td class="px-4 py-3"><%= entry.getKey() %></td>
                                <td class="px-4 py-3 text-center"><%= entry.getValue() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } %>

            <!-- Statistiques par Département -->
            <% if (statistiquesParDepartement != null && !statistiquesParDepartement.isEmpty()) { %>
            <div class="bg-white rounded-lg shadow p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">🏢 Statistiques par Département</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <%
                    for (Map.Entry<String, Map<String, Object>> entry : statistiquesParDepartement.entrySet()) {
                        String dept = entry.getKey();
                        Map<String, Object> stats = entry.getValue();
                    %>
                    <div class="bg-gradient-to-r from-blue-500 to-purple-600 text-white p-6 rounded-lg shadow-lg">
                        <h3 class="text-lg font-bold mb-4"><%= dept %></h3>
                        <div class="space-y-2">
                            <div class="flex justify-between">
                                <span>Total:</span>
                                <span class="font-bold"><%= stats.get("total") %></span>
                            </div>
                            <div class="flex justify-between">
                                <span>Entrées:</span>
                                <span class="font-bold"><%= stats.get("entrees") %></span>
                            </div>
                            <div class="flex justify-between">
                                <span>Sorties:</span>
                                <span class="font-bold"><%= stats.get("sorties") %></span>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <!-- Statuts Actuels des Personnels -->
            <% if (statutsPersonnels != null && !statutsPersonnels.isEmpty()) { %>
            <div class="bg-white rounded-lg shadow p-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">📋 Statuts Actuels des Personnels</h2>
                <%
                for (Map.Entry<String, List<Map<String, Object>>> entry : statutsPersonnels.entrySet()) {
                    String departement = entry.getKey();
                    List<Map<String, Object>> personnelsDept = entry.getValue();
                %>
                <div class="mb-8">
                    <h3 class="text-xl font-bold text-gray-700 mb-4">🏢 <%= departement %> (<%= personnelsDept.size() %> personnel(s))</h3>
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-900">
                            <thead class="text-xs uppercase text-gray-600 bg-gray-200">
                                <tr>
                                    <th class="px-4 py-3">Nom du Personnel</th>
                                    <th class="px-4 py-3 text-center">Matricule</th>
                                    <th class="px-4 py-3 text-center">Statut</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                for (Map<String, Object> personnel : personnelsDept) {
                                    String nomComplet = personnel.get("nom") + " " + personnel.get("prenom");
                                    String matricule = (String) personnel.get("matricule");
                                    String statut = (String) personnel.get("statut");
                                %>
                                <tr class="border-b border-gray-200 hover:bg-gray-50">
                                    <td class="px-4 py-3"><%= nomComplet %></td>
                                    <td class="px-4 py-3 text-center"><%= matricule != null ? matricule : "N/A" %></td>
                                    <td class="px-4 py-3 text-center">
                                        <span class="<%= "Présent".equals(statut) ? "present" : "absent" %>"><%= statut %></span>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </main>
    </div>

    <script>
        const btnToggleSidebar = document.getElementById('btn-toggle-sidebar');
        const sidebar = document.getElementById('sidebar');
        if (btnToggleSidebar && sidebar) {
            btnToggleSidebar.addEventListener('click', () => {
                sidebar.classList.toggle('-translate-x-full');
            });
        }
    </script>
</body>
</html>
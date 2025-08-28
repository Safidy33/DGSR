<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="models.Pointage" %>
<%@ page import="models.Personnel" %>

<%
    String adminName = "Admin";
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }

    // Récupération des données du servlet
    List<Pointage> pointages = (List<Pointage>) request.getAttribute("pointages");
    List<Personnel> tousPersonnels = (List<Personnel>) request.getAttribute("tousPersonnels");
    List<String> tousDepartements = (List<String>) request.getAttribute("tousDepartements");
    Map<String, Object> statistiques = (Map<String, Object>) request.getAttribute("statistiques");
    
    // Récupération des paramètres de filtrage
    String dateDebut = (String) request.getAttribute("dateDebut");
    String dateFin = (String) request.getAttribute("dateFin");
    String personnelId = (String) request.getAttribute("personnelId");
    String departement = (String) request.getAttribute("departement");
    String periode = (String) request.getAttribute("periode");
    
    if (dateDebut == null) dateDebut = "";
    if (dateFin == null) dateFin = "";
    if (personnelId == null) personnelId = "tous";
    if (departement == null) departement = "tous";
    if (periode == null) periode = "personnalise";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Rapport - Système de Gestion de Pointage</title>
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
    .nav-item.active {
      background-color: #3b82f6;
      color: white !important;
      font-weight: 600;
      border-radius: 0.5rem;
    }
    .status-dot {
      border-radius: 9999px;
      height: 14px;
      width: 14px;
      display: inline-block;
    }
    .scrollable-y { max-height: 400px; overflow-y: auto; }
    input[type="date"]::-webkit-calendar-picker-indicator {
      filter: invert(33%) sepia(88%) saturate(538%) hue-rotate(355deg) brightness(89%) contrast(88%);
      cursor: pointer;
    }
    .btn-primary {
      background: linear-gradient(135deg, #3b82f6, #2563eb);
      color: white;
      font-weight: 600;
      padding: 0.5rem 1.5rem;
      border-radius: 0.5rem;
      transition: all 0.3s ease;
    }
    .btn-primary:hover {
      background: linear-gradient(135deg, #2563eb, #1d4ed8);
      transform: translateY(-1px);
      box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
    }
    .btn-secondary {
      background: linear-gradient(135deg, #ef4444, #dc2626);
      color: white;
      font-weight: 600;
      padding: 0.5rem 1.5rem;
      border-radius: 0.5rem;
      transition: all 0.3s ease;
    }
    .btn-secondary:hover {
      background: #dc2626;
      transform: translateY(-1px);
      box-shadow: 0 4px 6px -1px rgba(239, 68, 68, 0.3);
    }
  </style>
</head>
<body class="bg-white font-sans text-gray-800 min-h-screen flex flex-col">

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
      <div class="flex items-center space-x-2">
          <span class="font-semibold"><%= adminName %></span>
      </div>
      <a href="LogoutServlet" class="btn-deconnexion text-white font-bold px-6 py-2 rounded-xl shadow-lg hover:shadow-2xl transition">
          Déconnexion
      </a>
    </div>
  </header>

  <div class="flex flex-1 min-h-0">
    
    <jsp:include page="Menu_rapide.jsp">
        <jsp:param name="currentPage" value="rapport" />
    </jsp:include>

    <!-- MAIN CONTENT -->
    <main class="flex-1 overflow-auto p-6">
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8">
        <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Tableau de Bord</a>
        <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="RapportServlet" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <section class="max-w-6xl mx-auto mb-16">
        
        <!-- Formulaire de filtrage -->
        <div class="bg-white rounded-lg shadow p-6 mb-8">
          <h2 class="text-xl font-bold text-gray-800 mb-6">📊 Filtres et Paramètres de Rapport</h2>
          
          <form action="RapportServlet" method="get" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <input type="hidden" name="action" value="generer_rapport">
            
            <!-- Période prédéfinie -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">📅 Période</label>
              <select name="periode" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="personnalise" <%= "personnalise".equals(periode) ? "selected" : "" %>>Personnalisée</option>
                <option value="aujourdhui" <%= "aujourdhui".equals(periode) ? "selected" : "" %>>Aujourd'hui</option>
                <option value="semaine" <%= "semaine".equals(periode) ? "selected" : "" %>>Cette semaine</option>
                <option value="mois" <%= "mois".equals(periode) ? "selected" : "" %>>Ce mois</option>
              </select>
            </div>
            
            <!-- Date de début -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">📆 Date de début</label>
              <input type="date" name="date_debut" value="<%= dateDebut %>" 
                     class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>
            
            <!-- Date de fin -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">📆 Date de fin</label>
              <input type="date" name="date_fin" value="<%= dateFin %>" 
                     class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>
            
            <!-- Personnel -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">👤 Personnel</label>
              <select name="personnel_id" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="tous">Tous les personnels</option>
                <% if (tousPersonnels != null) { 
                    for (Personnel p : tousPersonnels) { %>
                <option value="<%= p.getId() %>" <%= String.valueOf(p.getId()).equals(personnelId) ? "selected" : "" %>>
                  <%= p.getNom() %> <%= p.getPrenom() %>
                </option>
                <% } } %>
              </select>
            </div>
            
            <!-- Département -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">🏢 Département</label>
              <select name="departement" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="tous">Tous les départements</option>
                <% if (tousDepartements != null) { 
                    for (String dept : tousDepartements) { %>
                <option value="<%= dept %>" <%= dept.equals(departement) ? "selected" : "" %>>
                  <%= dept %>
                </option>
                <% } } %>
              </select>
            </div>
            
            <!-- Boutons -->
            <div class="md:col-span-2 lg:col-span-4 flex space-x-4 mt-4">
              <button type="submit" class="btn-primary">
                🔍 Générer Rapport
              </button>
              <button type="button" onclick="exporterPDF()" class="btn-secondary">
                📄 Exporter en PDF
              </button>
            </div>
          </form>
        </div>

        <!-- Statistiques -->
        <% if (statistiques != null) { %>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-lg p-6 shadow-lg">
            <div class="text-3xl font-bold"><%= statistiques.get("totalPointages") %></div>
            <div class="text-sm opacity-90">Total Pointages</div>
          </div>
          <div class="bg-gradient-to-r from-green-500 to-green-600 text-white rounded-lg p-6 shadow-lg">
            <div class="text-3xl font-bold"><%= statistiques.get("entrees") %></div>
            <div class="text-sm opacity-90">Entrées</div>
          </div>
          <div class="bg-gradient-to-r from-red-500 to-red-600 text-white rounded-lg p-6 shadow-lg">
            <div class="text-3xl font-bold"><%= statistiques.get("sorties") %></div>
            <div class="text-sm opacity-90">Sorties</div>
          </div>
        </div>
        <% } %>

        <!-- Tableau des pointages -->
        <% if (pointages != null && !pointages.isEmpty()) { %>
        <div class="bg-gray-50 rounded-lg shadow p-6">
          <div class="border border-gray-400 rounded-lg inline-block px-3 py-1 text-sm font-semibold select-none mb-4">
            📋 Pointages filtrés (<%= pointages.size() %> résultats)
          </div>

          <div class="overflow-x-auto">
            <table class="w-full text-sm text-left text-gray-900 border-collapse">
              <thead class="text-xs uppercase text-gray-600 bg-gray-200">
                <tr>
                  <th class="px-4 py-3 font-semibold text-center">Nom</th>
                  <th class="px-4 py-3 font-semibold text-center">Date</th>
                  <th class="px-4 py-3 font-semibold text-center">Heure</th>
                  <th class="px-4 py-3 font-semibold text-center">Type</th>
                  <th class="px-4 py-3 font-semibold text-center">Statut</th>
                </tr>
              </thead>
              <tbody>
                <% 
                for (Pointage pt : pointages) {
                    String nomComplet = pt.getNomPersonnel() + " " + pt.getPrenomPersonnel();
                    String date = pt.getDatePointage().toLocalDateTime().toLocalDate().toString();
                    String heure = pt.getDatePointage().toLocalDateTime().toLocalTime().toString();
                    String type = pt.getType();
                    String statut = pt.getStatut();
                %>
                <tr class="border-b border-gray-200 hover:bg-gray-100">
                  <td class="px-4 py-3"><%= nomComplet %></td>
                  <td class="px-4 py-3 text-center"><%= date %></td>
                  <td class="px-4 py-3 text-center"><%= heure %></td>
                  <td class="px-4 py-3 text-center">
                    <span class="px-2 py-1 rounded-full text-xs font-medium 
                                <%= "entree".equals(type) ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800" %>">
                      <%= "entree".equals(type) ? "Entrée" : "Sortie" %>
                    </span>
                  </td>
                  <td class="px-4 py-3 text-center">
                    <span class="status-dot" style="background-color: <%= "present".equals(statut) ? "green" : "red" %>;" 
                          title="<%= "present".equals(statut) ? "Présent" : "Absent" %>"></span>
                  </td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>
        <% } else if (pointages != null && pointages.isEmpty()) { %>
        <div class="bg-gray-50 rounded-lg shadow p-6 text-center">
          <div class="text-gray-500 text-lg">Aucun pointage trouvé avec les filtres sélectionnés.</div>
        </div>
        <% } %>

      </section>
    </main>
  </div>

  <script>
    const btnToggleSidebar = document.getElementById('btn-toggle-sidebar');
    const sidebar = document.getElementById('sidebar');
    btnToggleSidebar.addEventListener('click', () => {
      sidebar.classList.toggle('-translate-x-full');
    });

    function exporterPDF() {
      alert('Fonctionnalité d\'export PDF à implémenter');
      // Implémentation future pour l'export PDF
    }

    // Gérer la sélection de période
    document.querySelector('select[name="periode"]').addEventListener('change', function() {
      const periode = this.value;
      const dateDebutInput = document.querySelector('input[name="date_debut"]');
      const dateFinInput = document.querySelector('input[name="date_fin"]');
      
      const today = new Date();
      
      if (periode === 'aujourdhui') {
        dateDebutInput.value = today.toISOString().split('T')[0];
        dateFinInput.value = today.toISOString().split('T')[0];
      } else if (periode === 'semaine') {
        const startOfWeek = new Date(today);
        startOfWeek.setDate(today.getDate() - today.getDay());
        dateDebutInput.value = startOfWeek.toISOString().split('T')[0];
        dateFinInput.value = today.toISOString().split('T')[0];
      } else if (periode === 'mois') {
        const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
        dateDebutInput.value = startOfMonth.toISOString().split('T')[0];
        dateFinInput.value = today.toISOString().split('T')[0];
      }
    });
  </script>

</body>
</html>

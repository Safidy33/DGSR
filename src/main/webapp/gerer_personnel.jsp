<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.Personnel" %>
<%
    String adminName = "Admin"; 
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }

    List<Personnel> personnels = (List<Personnel>) request.getAttribute("personnels");
    if (personnels == null) {
        personnels = java.util.Collections.emptyList();
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Gérer Personnel - Système de Gestion de Pointage</title>
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
    .action-btn {
      transition: all 0.2s ease;
    }
    .action-btn:hover {
      transform: scale(1.05);
    }
    .table-row:hover {
      background-color: #f9fafb;
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

	<jsp:include page="Menu_rapide.jsp" />

    <!-- MAIN CONTENT -->
    <main class="flex-1 overflow-auto p-6">
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8">
        <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Tableau de Bord</a>
        <a href="gerer_personnel.jsp" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Contenu principal -->
      <section class="max-w-6xl mx-auto">
        <div class="bg-white rounded-lg shadow-lg p-6">
          <!-- En-tête -->
          <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Gestion du Personnel</h1>
          </div>

          <!-- Barre de recherche -->
          <form method="get" action="gerer-personnel" class="flex flex-col md:flex-row gap-4 mb-6 w-full">
            <div class="flex-1">
              <input type="text" name="search"
                     value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>"
                     placeholder="Rechercher un personnel..." 
                     class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>
            <select name="departement" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
              <option value="" <%= (request.getParameter("departement") == null || request.getParameter("departement").isEmpty()) ? "selected" : "" %>>Tous les départements</option>
              <option value="Informatique" <%= "Informatique".equals(request.getParameter("departement")) ? "selected" : "" %>>Informatique</option>
              <option value="Administration" <%= "Administration".equals(request.getParameter("departement")) ? "selected" : "" %>>Administration</option>
              <option value="Comptabilité" <%= "Comptabilité".equals(request.getParameter("departement")) ? "selected" : "" %>>Comptabilité</option>
            </select>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition">Rechercher</button>
          </form>

          <!-- Tableau du personnel -->
          <div class="overflow-x-auto">
            <table class="w-full text-sm text-left text-gray-900">
              <thead class="text-xs uppercase text-gray-600 border-b border-gray-300 bg-gray-50">
                <tr>
                  <th class="px-4 py-3 font-semibold">ID</th>
                  <th class="px-4 py-3 font-semibold">Nom & Prénom</th>
                  <th class="px-4 py-3 font-semibold">Email</th>
                  <th class="px-4 py-3 font-semibold">Département</th>
                  <th class="px-4 py-3 font-semibold">Numéro Employé</th>
                  <th class="px-4 py-3 font-semibold">QR Code</th>
                  <th class="px-4 py-3 font-semibold text-center">Actions</th>
                </tr>
              </thead>
              <tbody>
                <% if (!personnels.isEmpty()) { %>
                  <% for (Personnel personnel : personnels) { %>
                    <tr class="border-b border-gray-200 table-row">
                      <td class="px-4 py-3"><%= personnel.getId() %></td>
                      <td class="px-4 py-3 font-medium"><%= personnel.getNom() %> <%= personnel.getPrenom() %></td>
                      <td class="px-4 py-3"><%= personnel.getEmail() %></td>
                      <td class="px-4 py-3"><%= personnel.getDepartement() %></td>
                      <td class="px-4 py-3"><%= personnel.getNumeroEmploye() %></td>
                      <td class="px-4 py-3"><%= personnel.getQrCode() != null ? personnel.getQrCode() : "" %></td>
                      <td class="px-4 py-3 text-center">
                        <div class="flex justify-center space-x-2">
                          <a href="gerer-personnel?action=edit&id=<%= personnel.getId() %>" 
                             class="text-blue-600 hover:text-blue-800 transition p-1 action-btn" 
                             title="Modifier">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                            </svg>
                          </a>
                          <a href="gerer-personnel?action=delete&id=<%= personnel.getId() %>" 
                             onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce personnel ?')"
                             class="text-red-600 hover:text-red-800 transition p-1 action-btn" 
                             title="Supprimer">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                          </a>
                        </div>
                      </td>
                    </tr>
                  <% } %>
                <% } else { %>
                  <tr>
                    <td colspan="6" class="text-center py-8 text-gray-500">Aucun personnel trouvé.</td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </main>
  </div>

  <script>
    const btnToggleSidebar = document.getElementById('btn-toggle-sidebar');
    const sidebar = document.getElementById('sidebar');
    btnToggleSidebar.addEventListener('click', () => {
      sidebar.classList.toggle('-translate-x-full');
    });
  </script>

</body>
</html>

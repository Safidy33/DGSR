<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.Personnel" %>
<%
    String adminName = "Admin"; // valeur par défaut
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }

    // Récupération de la liste des personnels
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

    <!-- SIDEBAR -->
    <aside id="sidebar"
           class="fixed top-0 left-0 z-40 w-56 h-full bg-white border-r border-gray-200 py-6 overflow-y-auto
                  transform -translate-x-full transition-transform duration-300 ease-in-out
                  md:relative md:translate-x-0 md:flex md:flex-col">
      <h2 class="px-6 font-bold text-lg flex items-center justify-between mb-6 cursor-default">
        Menu Rapide
      </h2>
      <nav class="flex flex-col space-y-6 text-gray-700 px-6">
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 stroke-current" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                <path d="M12 4v16m8-8H4"/>
            </svg>
            <span>Nouveau personnel</span>
        </a>
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 stroke-current" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                <path d="M3 7h18M3 12h18M3 17h18"/>
            </svg>
            <span>Générer Rapport</span>
        </a>
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 stroke-current" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="3"/>
                <path d="M19 21v-2a4 4 0 00-4-4H9a4 4 0 00-4 4v2"/>
            </svg>
            <span>Voir Présents</span>
        </a>
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 stroke-current" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="3"/>
                <path d="M17 16v3m-10-3v3"/>
            </svg>
            <span>Voir Absents</span>
        </a>
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 stroke-current" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                <path d="M3 3v18h18"/>
                <path d="M16 9v6M9 12h6"/>
            </svg>
            <span>Statistique</span>
        </a>
      </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="flex-1 overflow-auto p-6">
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8">
        <a href="dashboard.jsp" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Tableau de Bord</a>
        <a href="gerer_personnel.jsp" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Gérer Personnel</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Contenu principal -->
      <section class="max-w-6xl mx-auto">
        <div class="bg-white rounded-lg shadow-lg p-6">
          <!-- En-tête avec titre et bouton ajouter -->
          <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Gestion du Personnel</h1>
            <button class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition action-btn flex items-center space-x-2">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                <path d="M12 4v16m8-8H4"/>
              </svg>
              <span>Ajouter Personnel</span>
            </button>
          </div>

          <!-- Barre de recherche et filtres -->
          <div class="flex flex-col md:flex-row gap-4 mb-6">
            <div class="flex-1">
              <input type="text" placeholder="Rechercher un personnel..." 
                     class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
            </div>
            <select class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
              <option value="">Tous les départements</option>
              <option value="Informatique">Informatique</option>
              <option value="Administration">Administration</option>
              <option value="Comptabilité">Comptabilité</option>
            </select>
          </div>

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
                  <th class="px-4 py-3 font-semibold text-center">Actions</th>
                </tr>
              </thead>
              <tbody>
                <% if (personnels != null && !personnels.isEmpty()) { %>
                  <% for (Personnel personnel : personnels) { %>
                    <tr class="border-b border-gray-200 table-row">
                      <td class="px-4 py-3"><%= personnel.getId() %></td>
                      <td class="px-4 py-3 font-medium"><%= personnel.getNom() %> <%= personnel.getPrenom() %></td>
                      <td class="px-4 py-3"><%= personnel.getEmail() %></td>
                      <td class="px-4 py-3"><%= personnel.getDepartement() %></td>
                      <td class="px-4 py-3"><%= personnel.getNumeroEmploye() %></td>
                      <td class="px-4 py-3">
                        <div class="flex justify-center space-x-2">
                          <button class="text-blue-600 hover:text-blue-800 action-btn" title="Modifier">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                            </svg>
                          </button>
                          <button class="text-red-600 hover:text-red-800 action-btn" title="Supprimer">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                              <polyline points="3 6 5 6 21 6"/>
                              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                            </svg>
                          </button>
                          <button class="text-green-600 hover:text-green-800 action-btn" title="Voir détails">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                              <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                              <circle cx="12" cy="12" r="3"/>
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                  <% } %>
                <% } else { %>
                  <tr>
                    <td colspan="6" class="text-center py-8 text-gray-500">
                      Aucun personnel trouvé dans la base de données.
                    </td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="flex justify-between items-center mt-6">
            <div class="text-sm text-gray-700">
              <% if (personnels != null) { %>
                Affichage de 1 à <%= personnels.size() %> sur <%= personnels.size() %> résultat(s)
              <% } %>
            </div>
            <div class="flex space-x-2">
              <button class="px-3 py-1 border border-gray-300 rounded-md text-sm text-gray-700 hover:bg-gray-50">Précédent</button>
              <button class="px-3 py-1 bg-blue-600 text-white rounded-md text-sm">1</button>
              <button class="px-3 py-1 border border-gray-300 rounded-md text-sm text-gray-700 hover:bg-gray-50">Suivant</button>
            </div>
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

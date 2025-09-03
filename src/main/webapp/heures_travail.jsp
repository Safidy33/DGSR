<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="servlets.HeureDeTravailServlet.HeureDeTravail" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    String adminName = "Admin";
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }

    List<HeureDeTravail> heuresJour = (List<HeureDeTravail>) request.getAttribute("heuresJour");
    List<HeureDeTravail> heuresSemaine = (List<HeureDeTravail>) request.getAttribute("heuresSemaine");
    List<HeureDeTravail> heuresMois = (List<HeureDeTravail>) request.getAttribute("heuresMois");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>Heures de Travail - Système de Gestion de Pointage</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    function switchTab(tabId) {
      // Masquer tous les contenus d'onglets
      document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
      document.getElementById(tabId).classList.remove('hidden');

      // Réinitialiser tous les boutons
      document.querySelectorAll('.tab-btn').forEach(el => {
        el.classList.remove('bg-gradient-to-r', 'from-blue-600', 'to-blue-800', 'text-white', 'shadow-lg', 'scale-105');
        el.classList.add('bg-gray-200', 'text-gray-700', 'hover:bg-gray-300');
      });
      
      // Activer le bouton cliqué
      const activeBtn = document.querySelector('[data-tab="' + tabId + '"]');
      activeBtn.classList.remove('bg-gray-200', 'text-gray-700', 'hover:bg-gray-300');
      activeBtn.classList.add('bg-gradient-to-r', 'from-blue-600', 'to-blue-800', 'text-white', 'shadow-lg', 'scale-105');
    }
  </script>
  <style>
    .tab-btn {
      transition: all 0.3s ease;
    }
    .tab-btn:hover {
      transform: translateY(-2px);
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

    /* Style professionnel pour le titre principal */
    .main-title {
      color: #1f2937;
      font-size: 2.25rem;
      font-weight: 700;
      margin-bottom: 2rem;
      position: relative;
      display: flex;
      align-items: center;
      gap: 0.75rem;
      letter-spacing: -0.5px;
    }

    .main-title::after {
      content: '';
      position: absolute;
      bottom: -12px;
      left: 0;
      width: 60px;
      height: 3px;
      background: #1e40af;
      border-radius: 2px;
    }

    .title-icon {
      background: #1e40af;
      color: white;
      padding: 0.625rem;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(30, 64, 175, 0.15);
      transition: all 0.2s ease;
    }

    .title-icon:hover {
      background: #1d4ed8;
      transform: translateY(-1px);
      box-shadow: 0 6px 16px rgba(30, 64, 175, 0.2);
    }

    @media (max-width: 768px) {
      .main-title {
        font-size: 1.875rem;
      }
      .main-title::after {
        width: 40px;
        height: 2px;
      }
    }
  </style>
</head>
<body class="bg-gray-50 font-sans text-gray-800 min-h-screen flex flex-col">

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
    <div class="leading-tight font-semibold">
      <div>Système de Gestion</div>
      <div>de Pointage</div>
    </div>
  </div>
  <div class="flex items-center space-x-4">
    <span class="font-semibold"><%= adminName %></span>
    <a href="LogoutServlet" class="btn-deconnexion text-white font-bold px-6 py-2 rounded-xl shadow-lg hover:shadow-2xl transition">
      Déconnexion
    </a>
  </div>
</header>

<div class="flex flex-1 min-h-0">
  <jsp:include page="Menu_rapide.jsp">
    <jsp:param name="currentPage" value="heures_travail" />
  </jsp:include>

  <main class="flex-1 overflow-auto p-6">
    <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8 mx-auto justify-center">
      <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer">Tableau de Bord</a>
      <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
      <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
      <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
      <a href="HeureDeTravailServlet" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Heures de Travails</a>
    </nav>

    <h2 class="main-title">
      <div class="title-icon">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
      </div>
      Heures de Travail
    </h2>

    <!-- Onglets avec nouveau design -->
    <div class="flex space-x-2 mb-8 p-1 bg-gray-100 rounded-xl shadow-inner">
      <button data-tab="jour" onclick="switchTab('jour')" 
              class="tab-btn bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-lg scale-105 px-6 py-3 rounded-lg font-semibold flex-1 flex items-center justify-center space-x-2">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
        </svg>
        <span>Jour</span>
      </button>
      
      <button data-tab="semaine" onclick="switchTab('semaine')" 
              class="tab-btn bg-gray-200 text-gray-700 hover:bg-gray-300 px-6 py-3 rounded-lg font-semibold flex-1 flex items-center justify-center space-x-2">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
        </svg>
        <span>Semaine</span>
      </button>
      
      <button data-tab="mois" onclick="switchTab('mois')" 
              class="tab-btn bg-gray-200 text-gray-700 hover:bg-gray-300 px-6 py-3 rounded-lg font-semibold flex-1 flex items-center justify-center space-x-2">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
        </svg>
        <span>Mois</span>
      </button>
    </div>

    <!-- Tableau Jour -->
    <div id="jour" class="tab-content">
      <div class="bg-white rounded-xl shadow-lg p-6">
        <h3 class="text-xl font-bold mb-6 text-gray-800 flex items-center">
          <div class="w-1 h-6 bg-blue-500 rounded-full mr-3"></div>
          Heures par Jour
        </h3>
        <div class="overflow-x-auto">
          <table class="w-full text-sm border-collapse">
            <thead>
              <tr class="bg-gradient-to-r from-gray-50 to-gray-100">
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Nom Complet</th>
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Date</th>
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Heures Travaillées</th>
              </tr>
            </thead>
            <tbody>
              <% if (heuresJour != null && !heuresJour.isEmpty()) {
                   for (HeureDeTravail h : heuresJour) { %>
                <tr class="border-b border-gray-100 hover:bg-blue-50 transition-colors">
                  <td class="px-6 py-4 font-medium text-gray-900"><%= h.getNomComplet() %></td>
                  <td class="px-6 py-4 text-gray-600"><%= sdf.format(h.getDateTravail()) %></td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full font-semibold"><%= h.getHeures() %></span>
                  </td>
                </tr>
              <% } } else { %>
                <tr><td colspan="3" class="text-center py-8 text-gray-500">Aucune donnée disponible</td></tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Tableau Semaine -->
    <div id="semaine" class="tab-content hidden">
      <div class="bg-white rounded-xl shadow-lg p-6">
        <h3 class="text-xl font-bold mb-6 text-gray-800 flex items-center">
          <div class="w-1 h-6 bg-green-500 rounded-full mr-3"></div>
          Heures par Semaine
        </h3>
        <div class="overflow-x-auto">
          <table class="w-full text-sm border-collapse">
            <thead>
              <tr class="bg-gradient-to-r from-gray-50 to-gray-100">
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Nom Complet</th>
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Période</th>
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Total Heures</th>
              </tr>
            </thead>
            <tbody>
              <% if (heuresSemaine != null && !heuresSemaine.isEmpty()) {
                   for (HeureDeTravail h : heuresSemaine) { %>
                <tr class="border-b border-gray-100 hover:bg-green-50 transition-colors">
                  <td class="px-6 py-4 font-medium text-gray-900"><%= h.getNomComplet() %></td>
                  <td class="px-6 py-4 text-gray-600">Semaine du <%= (h.getDateTravail() != null ? sdf.format(h.getDateTravail()) : "") %></td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full font-semibold"><%= h.getHeures() %></span>
                  </td>
                </tr>
              <% } } else { %>
                <tr><td colspan="3" class="text-center py-8 text-gray-500">Aucune donnée disponible</td></tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Tableau Mois -->
    <div id="mois" class="tab-content hidden">
      <div class="bg-white rounded-xl shadow-lg p-6">
        <h3 class="text-xl font-bold mb-6 text-gray-800 flex items-center">
          <div class="w-1 h-6 bg-purple-500 rounded-full mr-3"></div>
          Heures par Mois
        </h3>
        <div class="overflow-x-auto">
          <table class="w-full text-sm border-collapse">
            <thead>
              <tr class="bg-gradient-to-r from-gray-50 to-gray-100">
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Nom Complet</th>
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Mois</th>
                <th class="px-6 py-4 text-left font-semibold text-gray-700 border-b-2 border-gray-200">Total Heures</th>
              </tr>
            </thead>
            <tbody>
              <% if (heuresMois != null && !heuresMois.isEmpty()) {
                   for (HeureDeTravail h : heuresMois) { 
                     // Extraire le nom et le mois
                     String nomComplet = h.getNomComplet();
                     String moisAnnee = "";
                     if (h.getDateTravail() != null) {
                       java.time.LocalDate date = h.getDateTravail().toLocalDate();
                       int moisNum = date.getMonthValue();
                       int annee = date.getYear();
                       
                       String[] moisFrancais = {"", "JANVIER", "FÉVRIER", "MARS", "AVRIL", "MAI", "JUIN",
                                               "JUILLET", "AOÛT", "SEPTEMBRE", "OCTOBRE", "NOVEMBRE", "DÉCEMBRE"};
                       moisAnnee = moisFrancais[moisNum] + " " + annee;
                     }
              %>
                <tr class="border-b border-gray-100 hover:bg-purple-50 transition-colors">
                  <td class="px-6 py-4 font-medium text-gray-900"><%= nomComplet %></td>
                  <td class="px-6 py-4 text-gray-600"><%= moisAnnee %></td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 bg-purple-100 text-purple-800 rounded-full font-semibold"><%= h.getHeures() %></span>
                  </td>
                </tr>
              <% } } else { %>
                <tr><td colspan="3" class="text-center py-8 text-gray-500">Aucune donnée disponible</td></tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

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
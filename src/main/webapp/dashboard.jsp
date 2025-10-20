<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="models.Pointage" %>

<%
    String adminName = "Admin"; // valeur par défaut
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }

    // Récupération des attributs envoyés par le servlet
    int presentCount = (request.getAttribute("presentCount") != null) ? (int) request.getAttribute("presentCount") : 0;
    int absentCount = (request.getAttribute("absentCount") != null) ? (int) request.getAttribute("absentCount") : 0;
    int totalPersonnel = (request.getAttribute("totalPersonnel") != null) ? (int) request.getAttribute("totalPersonnel") : 0;
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dashboard Système de Gestion de Pointage</title>
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
    .stat-card {
      background: white;
      border-radius: 1rem;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
      padding: 1.5rem;
      text-align: center;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .stat-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }
    .stat-icon {
      width: 3rem;
      height: 3rem;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 0.75rem;
    }
    .present-icon {
      background: linear-gradient(135deg, #10b981, #059669);
    }
    .absent-icon {
      background: linear-gradient(135deg, #ef4444, #dc2626);
    }
    .total-icon {
      background: linear-gradient(135deg, #6b7280, #4b5563);
    }

    /* Styles ajustés pour les tableaux */
    .table-container {
      background: white;
      border-radius: 0.75rem;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      overflow: hidden;
      margin-bottom: 1.5rem;
    }
    
    .table-header {
      background: linear-gradient(135deg, #3b82f6, #1d4ed8);
      color: white;
      padding: 1rem 1.5rem;
      font-weight: 600;
      font-size: 1.1rem;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    
    .table-header.bg-red {
      background: linear-gradient(135deg, #ef4444, #dc2626);
    }
    
    .custom-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.875rem;
    }
    
    .custom-table thead {
      background-color: #f8fafc;
      border-bottom: 2px solid #e2e8f0;
    }
    
    .custom-table th {
      padding: 0.75rem 1rem;
      text-align: left;
      font-weight: 600;
      color: #475569;
      text-transform: uppercase;
      font-size: 0.75rem;
      letter-spacing: 0.05em;
    }
    
    .custom-table td {
      padding: 0.75rem 1rem;
      border-bottom: 1px solid #e2e8f0;
      color: #374151;
    }
    
    .custom-table tbody tr {
      transition: background-color 0.2s ease;
    }
    
    .custom-table tbody tr:hover {
      background-color: #f8fafc;
    }
    
    .custom-table tbody tr:last-child td {
      border-bottom: none;
    }
    
    /* Alignements spécifiques */
    .text-center-table {
      text-align: center;
    }
    
    .text-left-table {
      text-align: left;
    }
    
    .text-right-table {
      text-align: right;
    }
    
    /* Badge pour les en-têtes de tableau */
    .table-badge {
      background: rgba(255, 255, 255, 0.2);
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: 0.5rem;
      padding: 0.25rem 0.75rem;
      font-size: 0.75rem;
      font-weight: 500;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
      .table-container {
        border-radius: 0.5rem;
        margin-bottom: 1rem;
      }
      
      .custom-table {
        font-size: 0.8rem;
      }
      
      .custom-table th,
      .custom-table td {
        padding: 0.5rem 0.75rem;
      }
      
      .table-header {
        padding: 0.75rem 1rem;
        font-size: 1rem;
      }
    }

    /* Layout principal ajusté */
    .main-content-grid {
      display: grid;
      grid-template-columns: 2fr 1fr;
      gap: 1.5rem;
      align-items: start;
    }
    
    @media (max-width: 1024px) {
      .main-content-grid {
        grid-template-columns: 1fr;
        gap: 1rem;
      }
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
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8 mx-auto justify-center">
        <a href="PointageServlet" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Tableau de Bord</a>
        <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="HeureDeTravailServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Contenu dynamique avec nouveau layout -->
      <section class="max-w-6xl mx-auto mb-16">
        <div class="main-content-grid">
          
          <!-- Section gauche avec les tableaux -->
          <div class="space-y-6">
            
            <!-- Tableau Pointages récents -->
            <div class="table-container">
              <div class="table-header">
                <span>Pointages récents</span>
                <span class="table-badge">Aujourd'hui</span>
              </div>
              <div class="overflow-x-auto">
                <table class="custom-table">
                  <thead>
                    <tr>
                      <th class="text-left-table">Nom</th>
                      <th class="text-center-table">Heure d'entrée</th>
                      <th class="text-center-table">Heure de sortie</th>
                      <th class="text-center-table">Statut</th>
                      <th class="text-center-table">Localisation</th>
                    </tr>
                  </thead>
                  <tbody>
                  <%
                    List<Pointage> pointages = (List<Pointage>) request.getAttribute("derniersPointages");
                    if (pointages != null && !pointages.isEmpty()) {
                      java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm");
                      java.util.TimeZone tz = java.util.TimeZone.getTimeZone("UTC");
                      sdf.setTimeZone(tz);

                      for (Pointage pt : pointages) {
                        String nomComplet = pt.getNomPersonnel() + " " + pt.getPrenomPersonnel();
                        String entree = (pt.getDatePointage() != null) ? sdf.format(pt.getDatePointage()) : "-";
                        String sortie = (pt.getDateSortie() != null) ? sdf.format(pt.getDateSortie()) : "-";

                        String couleurStatut = "-";
                        String tooltip = "-";
                        if (pt.getDatePointage() != null && pt.getDateSortie() == null) {
                          couleurStatut = "green";
                          tooltip = "En train de travailler";
                        } else if (pt.getDatePointage() != null && pt.getDateSortie() != null) {
                          couleurStatut = "red";
                          tooltip = "Sortie effectuée";
                        }
                  %>
                    <tr>
                      <td class="text-left-table"><%= nomComplet %></td>
                      <td class="text-center-table"><%= entree %></td>
                      <td class="text-center-table"><%= sortie %></td>
                      <td class="text-center-table">
                        <% if (!"-".equals(couleurStatut)) { %>
                          <span class="status-dot" style="background-color: <%= couleurStatut %>;" title="<%= tooltip %>"></span>
                        <% } %>
                      </td>
                      <td class="text-center-table"><%= pt.getLocalisation() != null ? pt.getLocalisation() : "-" %></td>
                    </tr>
                  <%
                      }
                    } else {
                  %>
                    <tr>
                      <td colspan="5" class="text-center-table py-4 text-gray-500">Aucun pointage récent à afficher.</td>
                    </tr>
                  <%
                    }
                  %>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- Tableau Personnels en Retard -->
            <div class="table-container">
              <div class="table-header bg-red">
                <span>Personnels en retard</span>
                <span class="table-badge">Alertes</span>
              </div>
              <div class="overflow-x-auto">
                <table class="custom-table">
                  <thead>
                    <tr>
                      <th class="text-left-table">Nom</th>
                      <th class="text-center-table">Heure d'entrée</th>
                    </tr>
                  </thead>
                  <tbody>
                  <%
                    List<Pointage> personnelsEnRetard = (List<Pointage>) request.getAttribute("personnelsEnRetard");
                    if (personnelsEnRetard != null && !personnelsEnRetard.isEmpty()) {
                      java.text.SimpleDateFormat sdfRetard = new java.text.SimpleDateFormat("HH:mm");
                      java.util.TimeZone tzRetard = java.util.TimeZone.getTimeZone("UTC");
                      sdfRetard.setTimeZone(tzRetard);

                      for (Pointage pt : personnelsEnRetard) {
                        String nomComplet = pt.getNomPersonnel() + " " + pt.getPrenomPersonnel();
                        String entree = (pt.getDatePointage() != null) ? sdfRetard.format(pt.getDatePointage()) : "-";
                  %>
                    <tr>
                      <td class="text-left-table"><%= nomComplet %></td>
                      <td class="text-center-table"><%= entree %></td>
                    </tr>
                  <%
                      }
                    } else {
                  %>
                    <tr>
                      <td colspan="2" class="text-center-table py-4 text-gray-500">Aucun personnel en retard.</td>
                    </tr>
                  <%
                    }
                  %>
                  </tbody>
                </table>
              </div>
            </div>

          </div>

          <!-- Section statistiques à droite -->
          <div class="space-y-6">
            
            <!-- Carte Personnel Présent -->
            <div class="stat-card">
              <div class="stat-icon present-icon">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                  <path d="M16 21v-2a4 4 0 00-4-4H9a4 4 0 00-4 4v2"/>
                  <circle cx="12.5" cy="7" r="4"/>
                  <path d="M20 8v6M23 11h-6"/>
                </svg>
              </div>
              <h3 class="text-sm font-medium text-gray-500 mb-1">PERSONNEL PRÉSENT</h3>
              <p class="text-3xl font-bold text-gray-900"><%= presentCount %> <span class="text-sm font-normal text-gray-500">personnes</span></p>
              <a href="PointageServlet?action=voir_presents" class="inline-block mt-3 text-blue-500 text-sm hover:underline">Voir liste</a>
            </div>

            <!-- Carte Personnel Absent -->
            <div class="stat-card">
              <div class="stat-icon absent-icon">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                  <path d="M16 21v-2a4 4 0 00-4-4H9a4 4 0 00-4 4v2"/>
                  <circle cx="12.5" cy="7" r="4"/>
                  <path d="M18 8l5 5M23 8l-5 5"/>
                </svg>
              </div>
              <h3 class="text-sm font-medium text-gray-500 mb-1">PERSONNEL ABSENT</h3>
              <p class="text-3xl font-bold text-gray-900"><%= absentCount %> <span class="text-sm font-normal text-gray-500">personnes</span></p>
              <a href="PointageServlet?action=voir_absents" class="inline-block mt-3 text-blue-500 text-sm hover:underline">Voir liste</a>
            </div>

            <!-- Carte Total Personnel -->
            <div class="stat-card">
              <div class="stat-icon total-icon">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                  <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
                  <circle cx="9" cy="7" r="4"/>
                  <path d="M23 21v-2a4 4 0 00-3-3.87"/>
                  <path d="M16 3.13a4 4 0 010 7.75"/>
                </svg>
              </div>
              <h3 class="text-sm font-medium text-gray-500 mb-1">TOTAL PERSONNEL</h3>
              <p class="text-3xl font-bold text-gray-900"><%= totalPersonnel %> <span class="text-sm font-normal text-gray-500">personnes</span></p>
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
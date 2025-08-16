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
        <a href="#" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Tableau de Bord</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Contenu dynamique avec nouveau layout -->
      <section class="max-w-6xl mx-auto mb-16">
        <div class="grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-8">
          
          <!-- Section tableau de gauche -->
          <div class="bg-gray-50 rounded-lg shadow p-6 space-y-4">
            <div class="border border-gray-400 rounded-lg inline-block px-3 py-1 text-sm font-semibold select-none">
              Statut actuel
            </div>

            <table class="w-full text-sm text-left text-gray-900 border-collapse mt-4">
              <thead class="text-xs uppercase text-gray-600 border-b border-gray-300">
                <tr>
                  <th class="pl-3 py-2 font-semibold">Nom</th>
                  <th class="py-2 font-semibold text-center">Heure d'entrée</th>
                  <th class="py-2 font-semibold text-center">Heure de sortie</th>
                  <th class="pr-3 py-2 font-semibold text-center">Statut</th>
                </tr>
              </thead>
              <tbody>
              <%
                  List<Pointage> pointages = (List<Pointage>) request.getAttribute("derniersPointages");
                  if (pointages != null && !pointages.isEmpty()) {
                      Map<String, Map<String, String>> dernierParPersonnel = new LinkedHashMap<>();

                      for (Pointage pt : pointages) {
                          String nomComplet = pt.getNomPersonnel() + " " + pt.getPrenomPersonnel();
                          Map<String, String> heures = dernierParPersonnel.getOrDefault(nomComplet, new HashMap<>());

                          if ("entree".equalsIgnoreCase(pt.getType())) {
                              heures.put("entree", pt.getDatePointage().toLocalDateTime().toLocalTime().toString());
                          } else if ("sortie".equalsIgnoreCase(pt.getType())) {
                              heures.put("sortie", pt.getDatePointage().toLocalDateTime().toLocalTime().toString());
                          }

                          dernierParPersonnel.put(nomComplet, heures);
                      }

                      for (Map.Entry<String, Map<String, String>> entry : dernierParPersonnel.entrySet()) {
                          String nomComplet = entry.getKey();
                          Map<String, String> heures = entry.getValue();

                          String entree = heures.get("entree");
                          String sortie = heures.get("sortie");
                          String couleurStatut = "-";
                          String tooltip = "-";

                          if (entree != null && sortie == null) {
                              couleurStatut = "green";
                              tooltip = "En train de travailler";
                          } else if (entree != null && sortie != null) {
                              couleurStatut = "red";
                              tooltip = "Sortie effectuée";
                          }
              %>
                <tr class="border-b border-gray-200">
                  <td class="pl-3 py-2"><%= nomComplet %></td>
                  <td class="py-2 text-center"><%= heures.getOrDefault("entree", "-") %></td>
                  <td class="py-2 text-center"><%= heures.getOrDefault("sortie", "-") %></td>
                  <td class="pr-3 py-2 text-center">
                    <span class="status-dot" style="background-color: <%= couleurStatut %>;" title="<%= tooltip %>"></span>
                  </td>
                </tr>
              <%
                      }
              %>
                <!-- Légende en bas du tableau -->
                <tr>
                  <td colspan="4" class="pt-4">
                    <div class="flex items-center space-x-4 mt-2">
                      <div class="flex items-center space-x-1"><span class="status-dot" style="background-color: green;"></span><span>En cours</span></div>
                      <div class="flex items-center space-x-1"><span class="status-dot" style="background-color: red;"></span><span>En interruption</span></div>
                    </div>
                  </td>
                </tr>
              <%
                  } else {
              %>
                <tr>
                  <td colspan="4" class="text-center py-4">Aucun pointage récent à afficher.</td>
                </tr>
              <%
                  }
              %>
              </tbody>
            </table>
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
              <a href="#" class="inline-block mt-3 text-blue-500 text-sm hover:underline">Voir liste</a>
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
              <a href="#" class="inline-block mt-3 text-blue-500 text-sm hover:underline">Voir liste</a>
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
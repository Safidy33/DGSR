<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.Personnel" %>

<%
    String adminName = "Admin";
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }

    // Récupération des personnels absents
    List<Personnel> personnelsAbsents = (List<Personnel>) request.getAttribute("personnelsAbsents");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Personnel Absent - Système de Gestion de Pointage</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb {
      background-color: #ef4444;
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
    .scrollable-y { max-height: 400px; overflow-y: auto; }
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
        <jsp:param name="currentPage" value="voir_absents" />
    </jsp:include>

    <!-- MAIN CONTENT -->
    <main class="flex-1 overflow-auto p-6">
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8 mx-auto justify-center">
        <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Tableau de Bord</a>
        <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Tableau des personnels absents -->
      <section class="max-w-6xl mx-auto mb-16">
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold text-gray-800 flex items-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-red-600 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 12H6"/>
              </svg>
              Personnel Absent Aujourd'hui
            </h2>
            <span class="bg-red-100 text-red-800 text-sm font-medium px-3 py-1 rounded-full">
              <%= personnelsAbsents != null ? personnelsAbsents.size() : 0 %> personnes
            </span>
          </div>

          <% if (personnelsAbsents != null && !personnelsAbsents.isEmpty()) { %>
            <div class="overflow-x-auto">
              <table class="w-full text-sm text-left text-gray-900 border-collapse">
                <thead class="text-xs uppercase text-gray-600 bg-gray-100">
                  <tr>
                    <th class="px-6 py-4">Nom Complet</th>
                    <th class="px-6 py-4">Numéro Employé</th>
                    <th class="px-6 py-4">Département</th>
                    <th class="px-6 py-4">Email</th>
                  </tr>
                </thead>
                <tbody>
                  <% for (Personnel personnel : personnelsAbsents) { %>
                    <tr class="border-b border-gray-200 hover:bg-gray-50">
                      <td class="px-6 py-4 font-medium flex items-center">
                        <div class="w-8 h-8 bg-red-100 rounded-full flex items-center justify-center mr-3">
                          <span class="text-red-600 font-semibold text-sm">
                            <%= (personnel.getNom() != null && !personnel.getNom().isEmpty() ? personnel.getNom().charAt(0) : "") %><%= (personnel.getPrenom() != null && !personnel.getPrenom().isEmpty() ? personnel.getPrenom().charAt(0) : "") %>
                          </span>
                        </div>
                        <%= personnel.getNomComplet() %>
                      </td>
                      <td class="px-6 py-4"><%= personnel.getNumeroEmploye() %></td>
                      <td class="px-6 py-4">
                        <span class="bg-red-100 text-red-800 text-xs font-medium px-2 py-1 rounded-full">
                          <%= personnel.getDepartement() != null ? personnel.getDepartement() : "Non spécifié" %>
                        </span>
                      </td>
                      <td class="px-6 py-4 text-red-600 hover:underline">
                        <a href="mailto:<%= personnel.getEmail() %>"><%= personnel.getEmail() %></a>
                      </td>
                    </tr>
                  <% } %>
                </tbody>
              </table>
            </div>
          <% } else { %>
            <div class="text-center py-12 text-gray-500">
              <p class="text-lg font-medium mb-2">Aucun personnel absent aujourd'hui</p>
              <p class="text-sm">Tous les employés ont pointé leur présence.</p>
            </div>
          <% } %>
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

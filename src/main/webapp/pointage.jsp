<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.Pointage" %>

<%
    String adminName = "Admin";
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Pointage - Système de Gestion de Pointage</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    ::-webkit-scrollbar {
      width: 8px;
    }
    ::-webkit-scrollbar-track {
      background: transparent;
    }
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
    .scrollable-y {
      max-height: 400px;
      overflow-y: auto;
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
        <jsp:param name="currentPage" value="pointage" />
    </jsp:include>

    <!-- MAIN CONTENT -->
    <main class="flex-1 overflow-auto p-6">
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8 mx-auto justify-center">
        <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Tableau de Bord</a>
        <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Pointage</a>
        <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="HeureDeTravailServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>
<section class="max-w-6xl mx-auto mb-16">
  <div class="grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-8">

    <!-- ✅ Tableau des pointages du jour -->
    <div class="bg-gray-50 rounded-lg shadow p-6 space-y-4 ">
      <div class="border border-gray-400 rounded-lg inline-block px-3 py-1 text-sm font-semibold select-none">
        Pointages du jour
      </div>
  <jsp:include page="table_pointages.jsp">
    <jsp:param name="pointages" value="${pointagesDuJour}" />
  </jsp:include>
<div class="flex justify-center">
  <table class="max-w-4xl w-full text-sm text-left text-gray-900 border-collapse mt-4">
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
        List<Pointage> pointages = (List<Pointage>) request.getAttribute("pointagesDuJour");
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

<<<<<<< HEAD
            if (pt.getDatePointage() != null && pt.getDateSortie() == null) {
              couleurStatut = "green";
              tooltip = "En train de travailler";
            } else if (pt.getDatePointage() != null && pt.getDateSortie() != null) {
              couleurStatut = "red";
              tooltip = "Sortie effectuée";
=======
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
          <!-- ✅ Légende -->
          <tr>
            <td colspan="4" class="pt-4">
              <div class="flex items-center space-x-4 mt-2">
                <div class="flex items-center space-x-1"><span class="status-dot" style="background-color: green;"></span><span>En train de travailler</span></div>
                <div class="flex items-center space-x-1"><span class="status-dot" style="background-color: red;"></span><span>Sortie</span></div>
              </div>
            </td>
          </tr>
        <%
            } else {
        %>
          <tr>
            <td colspan="4" class="text-center py-4">Aucun pointage aujourd'hui.</td>
          </tr>
        <%
>>>>>>> 39346101d37159fcb0ec2706afca69d890eb05cd
            }
      %>
      <tr class="border-b border-gray-200">
        <td class="pl-3 py-2"><%= nomComplet %></td>
        <td class="py-2 text-center"><%= entree %></td>
        <td class="py-2 text-center"><%= sortie %></td>
        <td class="pr-3 py-2 text-center">
          <span class="status-dot" style="background-color: <%= couleurStatut %>;" title="<%= tooltip %>"></span>
        </td>
      </tr>
      <%
          }
        } else {
      %>
      <tr>
        <td colspan="4" class="text-center py-4">Aucun pointage aujourd'hui.</td>
      </tr>
      <%
        }
      %>
    </tbody>
  </table>
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

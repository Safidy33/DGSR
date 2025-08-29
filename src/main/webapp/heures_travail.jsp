<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="servlets.HeureDeTravailServlet.HeureDeTravail" %>

<%
    String adminName = "Admin";
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }

    List<HeureDeTravail> heures = (List<HeureDeTravail>) request.getAttribute("heuresTravail");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Heures de Travail - Système de Gestion de Pointage</title>
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

  <header class="bg-blue-900 text-white flex items-center justify-between px-6 py-3 select-none">
    <div class="flex items-center space-x-4">
      <img src="assets/img/logo_dgsr.png" alt="Logo DGS" class="w-14 h-14 object-cover"/>
      <div class="leading-tight font-semibold max-w-xs">
        <div>Système de Gestion</div>
        <div>de pointage</div>
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
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8">
        <a href="PointageServlet" class="nav-item px-4 py-2 hover:bg-blue-800">Tableau de Bord</a>
        <a href="gerer-personnel" class="nav-item px-4 py-2 hover:bg-blue-800">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 hover:bg-blue-800">Pointage</a>
        <a href="#" class="nav-item px-4 py-2 hover:bg-blue-800">Rapport</a>
        <a href="HeureDeTravailServlet" class="nav-item active px-4 py-2">Heures de Travails</a>
      </nav>

      <section class="max-w-6xl mx-auto mb-16">
        <div class="bg-white rounded-lg shadow p-6">
          <h2 class="text-2xl font-bold text-gray-800 mb-6">Heures de Travail</h2>
          <div class="overflow-x-auto">
            <table class="w-full text-sm text-left text-gray-900 border-collapse">
              <thead class="text-xs uppercase text-gray-600 bg-gray-100">
                <tr>
                  <th class="px-6 py-4">Nom Complet</th>
                  <th class="px-6 py-4">Date</th>
                  <th class="px-6 py-4">Heures Jour</th>
                  <th class="px-6 py-4">Heures Semaine</th>
                  <th class="px-6 py-4">Heures Mois</th>
                </tr>
              </thead>
              <tbody>
                <% if (heures != null && !heures.isEmpty()) {
                     for (HeureDeTravail h : heures) { %>
                  <tr class="border-b border-gray-200 hover:bg-gray-50">
                    <td class="px-6 py-4 font-medium"><%= h.getNomComplet() %></td>
                    <td class="px-6 py-4"><%= h.getDateTravail() %></td>
                    <td class="px-6 py-4"><%= h.getHeuresJour() %> </td>
                    <td class="px-6 py-4"><%= h.getHeuresSemaine() %> </td>
                    <td class="px-6 py-4"><%= h.getHeuresMois() %> </td>
                  </tr>
                <% } } else { %>
                  <tr><td colspan="5" class="text-center py-4 text-gray-500">Aucune donnée disponible</td></tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </main>
  </div>
</body>
</html>

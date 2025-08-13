<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = "Admin"; // valeur par défaut
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email"); // ou nom réel si stocké en session
    }
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

      <img
        src="assets/img/logo_dgsr.png"
        alt="Logo carré bleu et noir officiel de la Direction Générale Sécurité Routière"
        class="w-14 h-14 object-cover"
      />
      <div class="leading-tight font-semibold max-w-xs">
        <div>Système de Gestion</div>
        <div>de pointage</div>
      </div>
    </div>
    <div class="flex items-center space-x-4">
      <div class="flex items-center space-x-2">
        
        <span class="font-semibold"><%= adminName %></span>
      </div>
      <button class="btn-deconnexion text-white font-bold px-6 py-2 rounded-xl shadow-lg hover:shadow-2xl transition">
        Déconnexion
      </button>
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
      <!-- NAVIGATION TABS -->
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8">
        <a href="#" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Tableau de Bord</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Contenu dynamique -->
      <section class="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-[2fr_1fr] gap-8 mb-16">
        <div class="bg-gray-50 rounded-lg shadow p-6 space-y-4">
          <div class="border border-gray-400 rounded-lg inline-block px-3 py-1 text-sm font-semibold select-none">
            Statut actuel
          </div>
          <table class="w-full text-sm text-left text-gray-900 border-collapse">
            <thead class="text-xs uppercase text-gray-600 border-b border-gray-300">
              <tr>
                <th class="pl-3 py-2 font-semibold">Nom</th>
                <th class="py-2 font-semibold">Heure d'entrée</th>
                <th class="py-2 font-semibold">Heure de sortie</th>
                <th class="pr-3 py-2 font-semibold text-center">Statut</th>
              </tr>
            </thead>
            <tbody>
              <!-- Contenu dynamique -->
            </tbody>
          </table>
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

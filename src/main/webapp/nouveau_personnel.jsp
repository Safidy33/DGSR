<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
  <title>Nouveau Personnel - Système de Gestion de Pointage</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- ✅ Librairie adaptée au navigateur -->
  <script src="https://cdn.jsdelivr.net/npm/qrcodejs@1.0.0/qrcode.min.js"></script>
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
    .form-input:focus {
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }
    .form-group {
      transition: all 0.3s ease;
    }
    .form-group:hover {
      transform: translateY(-1px);
    }
    .section-header {
      border-left: 4px solid #3b82f6;
      background: linear-gradient(90deg, rgba(59, 130, 246, 0.05) 0%, transparent 100%);
    }
    .progress-bar {
      background: linear-gradient(90deg, #3b82f6, #1d4ed8);
      transition: width 0.3s ease;
    }
    .field-valid {
      border-color: #10b981 !important;
      background-color: rgba(16, 185, 129, 0.05);
    }
    .field-invalid {
      border-color: #ef4444 !important;
      background-color: rgba(239, 68, 68, 0.05);
    }
    .tooltip {
      visibility: hidden;
      opacity: 0;
      transition: opacity 0.3s, visibility 0.3s;
    }
    .tooltip.show {
      visibility: visible;
      opacity: 1;
    }
  </style>
</head>
<body class="bg-gray-50 font-sans text-gray-800 min-h-screen flex flex-col">

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
        <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Contenu principal -->
      <section class="max-w-5xl mx-auto">
        <div class="bg-white rounded-xl shadow-xl p-8">
          <!-- En-tête avec indicateur de progression -->
          <div class="mb-8">
            <div class="flex justify-between items-center mb-4">
              <h1 class="text-3xl font-bold text-gray-900 flex items-center">
                <svg class="w-8 h-8 text-blue-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>
                </svg>
                Ajouter un Nouveau Personnel
              </h1>
              <a href="gerer_personnel.jsp" class="bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition flex items-center">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                </svg>
                Retour à la liste
              </a>
            </div>

            <!-- Messages de notification -->
            <% String successMessage = request.getParameter("success"); %>
            <% String errorMessage = request.getParameter("error"); %>
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
              <div id="success-alert" class="mb-6 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg flex items-center justify-between">
                <div class="flex items-center">
                  <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                  </svg>
                  <span><%= successMessage %></span>
                </div>
                <button onclick="closeAlert('success-alert')" class="text-green-700 hover:text-green-900">
                  <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                  </svg>
                </button>
              </div>
            <% } %>
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
              <div id="error-alert" class="mb-6 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg flex items-center justify-between">
                <div class="flex items-center">
                  <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                  </svg>
                  <span><%= errorMessage %></span>
                </div>
                <button onclick="closeAlert('error-alert')" class="text-red-700 hover:text-red-900">
                  <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                  </svg>
                </button>
              </div>
            <% } %>
            
            <!-- Barre de progression -->
            <div class="bg-gray-200 rounded-full h-2 mb-2">
              <div id="progressBar" class="progress-bar h-2 rounded-full" style="width: 0%"></div>
            </div>
            <p class="text-sm text-gray-600">Progression: <span id="progressText">0/5 champs complétés</span></p>
          </div>

          

          <!-- Formulaire avec sections organisées -->
          <form action="gerer-personnel" method="post" class="space-y-8" id="personnelForm">
            <input type="hidden" name="action" value="add">
            
            <!-- Section 1: Informations personnelles -->
            <div class="section-header pl-4 py-3 mb-6">
              <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                <svg class="w-6 h-6 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
                Informations Personnelles
              </h2>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pl-6">
              <div class="form-group relative">
                <label for="nom" class="block text-sm font-medium text-gray-700 mb-2">
                  Nom <span class="text-red-500">*</span>
                </label>
                <input type="text" id="nom" name="nom" required
                       class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Entrez le nom de famille"
                       autocomplete="family-name">
                <div class="tooltip absolute left-0 top-full mt-1 bg-gray-800 text-white text-xs px-2 py-1 rounded">
                  Nom de famille du personnel
                </div>
              </div>
              
              <div class="form-group relative">
                <label for="prenom" class="block text-sm font-medium text-gray-700 mb-2">
                  Prénom <span class="text-red-500">*</span>
                </label>
                <input type="text" id="prenom" name="prenom" required
                       class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Entrez le prénom"
                       autocomplete="given-name">
                <div class="tooltip absolute left-0 top-full mt-1 bg-gray-800 text-white text-xs px-2 py-1 rounded">
                  Prénom du personnel
                </div>
              </div>
            </div>

            <!-- Section 2: Informations professionnelles -->
            <div class="section-header pl-4 py-3 mb-6">
              <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                <svg class="w-6 h-6 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2-2v2m8 0H8m8 0v2a2 2 0 002 2H6a2 2 0 002-2V6"/>
                </svg>
                Informations Professionnelles
              </h2>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pl-6">
              <div class="form-group relative">
                <label for="numeroEmploye" class="block text-sm font-medium text-gray-700 mb-2">
                  Numéro de Téléphone <span class="text-red-500">*</span>
                </label>
                <div class="relative">
                  <input type="text" id="numeroEmploye" name="numeroEmploye" required
                         class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent pl-12"
                         placeholder="Ex: 034 12 345 67"
                         pattern="^\+?[0-9\s\-\(\)]{10,15}$"
                         title="Format: numéro de téléphone valide (ex: 034 12 345 67)">
                  <svg class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                  </svg>
                </div>
                <small class="text-gray-500 text-xs mt-1 block">Format: 0XX XX XXX XX (Madagascar)</small>
              </div>
              
              <div class="form-group relative">
                <label for="departement" class="block text-sm font-medium text-gray-700 mb-2">
                  Département <span class="text-red-500">*</span>
                </label>
                <div class="relative">
                  <select id="departement" name="departement" required
                          class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent pl-12 appearance-none bg-white">
                    <option value="">-- Sélectionner un département --</option>
                    <option value="Informatique">💻 Informatique</option>
                    <option value="Administration">🏢 Administration</option>
                    <option value="Comptabilité">📊 Comptabilité</option>
                    <option value="Ressources Humaines">👥 Ressources Humaines</option>
                    <option value="Marketing">📢 Marketing</option>
                    <option value="Ventes">💼 Ventes</option>
                    <option value="Logistique">🚚 Logistique</option>
                    <option value="Juridique">⚖️ Juridique</option>
                  </select>
                  <svg class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                  </svg>
                  <svg class="w-4 h-4 text-gray-400 absolute right-3 top-1/2 transform -translate-y-1/2 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                  </svg>
                </div>
              </div>
            </div>

            <!-- Section 3: Contact -->
            <div class="section-header pl-4 py-3 mb-6">
              <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                <svg class="w-6 h-6 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                </svg>
                Informations de Contact
              </h2>
            </div>
            
            <div class="pl-6">
              <div class="form-group relative max-w-md">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                  Adresse Email <span class="text-red-500">*</span>
                </label>
                <div class="relative">
                  <input type="email" id="email" name="email" required
                         class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent pl-12"
                         placeholder="exemple@entreprise.com"
                         autocomplete="email">
                  <svg class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"/>
                  </svg>
                </div>
                <small class="text-gray-500 text-xs mt-1 block">Cette adresse sera utilisée pour les notifications</small>
              </div>
            </div>

            <!-- Section 4: QR Code -->
            <div class="section-header pl-4 py-3 mb-6">
              <h2 class="text-xl font-semibold text-gray-800 flex items-center">
                <svg class="w-6 h-6 text-blue-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z"/>
                </svg>
                Code QR pour Pointage (Optionnel)
              </h2>
            </div>
            
            <div class="pl-6">
              <div class="form-group">
                <label for="qrCode" class="block text-sm font-medium text-gray-700 mb-2">
                  Contenu du QR Code
                </label>
                <div class="flex flex-col md:flex-row md:items-start space-y-4 md:space-y-0 md:space-x-6">
                  <div class="flex-1">
                    <div class="flex items-center space-x-3">
                      <input type="text" id="qrCode" name="qrCode"
                             class="form-input flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                             placeholder="Sera généré automatiquement si laissé vide">
                      <button type="button" id="generateQR"
                              class="bg-green-500 text-white px-4 py-3 rounded-lg hover:bg-green-600 transition flex items-center">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                        </svg>
                        Générer
                      </button>
                    </div>
                    <small class="text-gray-500 text-xs mt-2 block">
                      Le QR Code est généré manuellement selon vos besoins
                    </small>
                  </div>
                  
                  <div id="qrPreview" class="hidden bg-gray-50 p-4 rounded-lg border-2 border-dashed border-gray-300">
                    <p class="text-sm text-gray-600 mb-2 text-center">Aperçu du QR Code</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Messages de validation en temps réel -->
            <div id="validationMessages" class="hidden pl-6"></div>

            <!-- Boutons d'action améliorés -->
            <div class="border-t pt-6">
              <div class="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
                <div class="text-sm text-gray-600">
                  <span class="flex items-center">
                    <svg class="w-4 h-4 text-green-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    Les données seront sauvegardées de façon sécurisée
                  </span>
                </div>
                
                <div class="flex space-x-4">
                  <button type="reset" 
                          class="bg-gray-500 text-white px-8 py-3 rounded-lg hover:bg-gray-600 transition flex items-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                    </svg>
                    Réinitialiser
                  </button>
                  <button type="submit" id="submitBtn"
                          class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition flex items-center disabled:opacity-50 disabled:cursor-not-allowed">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4"/>
                    </svg>
                    <span id="submitText">Enregistrer le personnel</span>
                  </button>
                </div>
              </div>
            </div>
          </form>
        </div>
      </section>
    </main>
  </div>

  <script>
    const btnToggleSidebar = document.getElementById('btn-toggle-sidebar');
    const sidebar = document.getElementById('sidebar');
    if (btnToggleSidebar && sidebar) {
      btnToggleSidebar.addEventListener('click', () => {
        sidebar.classList.toggle('-translate-x-full');
      });
    }

    // ===== AMÉLIORATIONS UX =====
    
    // 1. Validation en temps réel et barre de progression
    const requiredFields = ['nom', 'prenom', 'numeroEmploye', 'departement', 'email'];
    const progressBar = document.getElementById('progressBar');
    const progressText = document.getElementById('progressText');
    
    function updateProgress() {
      let completed = 0;
      requiredFields.forEach(fieldId => {
        const field = document.getElementById(fieldId);
        if (field && field.value.trim()) {
          completed++;
          field.classList.add('field-valid');
          field.classList.remove('field-invalid');
        } else {
          field.classList.remove('field-valid');
          if (field.value.length > 0) {
            field.classList.add('field-invalid');
          }
        }
      });
      
      const percentage = (completed / requiredFields.length) * 100;
      progressBar.style.width = percentage + '%';
      progressText.textContent = `${completed}/${requiredFields.length} champs complétés`;
    }
    
    // 2. Écouteurs pour la validation en temps réel
    requiredFields.forEach(fieldId => {
      const field = document.getElementById(fieldId);
      if (field) {
        field.addEventListener('input', updateProgress);
        field.addEventListener('change', updateProgress);
      }
    });

    // 3. Validation spéciale pour le numéro de téléphone
    document.getElementById('numeroEmploye').addEventListener('input', function(e) {
      const value = e.target.value.replace(/\s/g, ''); // Remove spaces for validation

      const pattern = /^(\+261|0)[0-9]{9}$/; // Madagascar phone format: +261XXXXXXXXX or 0XXXXXXXXX
      if (value && !pattern.test(value)) {
        e.target.classList.add('field-invalid');
        e.target.classList.remove('field-valid');
      } else if (value) {
        e.target.classList.remove('field-invalid');
        e.target.classList.add('field-valid');
      }
    });

    // 4. Génération QR Code manuelle uniquement

    // 5. Génération QR Code améliorée
    function generateQRCode(text) {
      const qrPreview = document.getElementById('qrPreview');
      qrPreview.innerHTML = "";
      qrPreview.classList.remove('hidden');

      // Création du QR Code avec options améliorées
      new QRCode(qrPreview, {
        text: text,
        width: 150,
        height: 150,
        colorDark: "#1e40af",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.M
      });
      
      // Ajout du texte sous le QR Code
      const textDiv = document.createElement('div');
      textDiv.className = 'text-xs text-gray-600 mt-2 text-center break-all';
      textDiv.textContent = text;
      qrPreview.appendChild(textDiv);
    }

    document.getElementById('generateQR').addEventListener('click', () => {
      const qrText = document.getElementById('qrCode').value.trim();
      if (!qrText) {
        alert('Veuillez entrer un texte pour générer le QR Code.');
        return;
      }
      generateQRCode(qrText);
    });

    // 6. Tooltips interactives
    document.querySelectorAll('.form-group').forEach(group => {
      const input = group.querySelector('input, select');
      const tooltip = group.querySelector('.tooltip');
      
      if (input && tooltip) {
        input.addEventListener('mouseenter', () => {
          tooltip.classList.add('show');
        });
        
        input.addEventListener('mouseleave', () => {
          tooltip.classList.remove('show');
        });
        
        input.addEventListener('focus', () => {
          tooltip.classList.add('show');
        });
        
        input.addEventListener('blur', () => {
          tooltip.classList.remove('show');
        });
      }
    });

    // 7. Validation du formulaire améliorée
    document.getElementById('personnelForm').addEventListener('submit', function(e) {
      const submitBtn = document.getElementById('submitBtn');
      const submitText = document.getElementById('submitText');
      
      // Validation des champs obligatoires
      let isValid = true;
      const errors = [];
      
      requiredFields.forEach(fieldId => {
        const field = document.getElementById(fieldId);
        if (!field.value.trim()) {
          isValid = false;
          errors.push(`Le champ ${field.previousElementSibling.textContent.replace('*', '').trim()} est obligatoire`);
          field.classList.add('field-invalid');
        }
      });
      
      // Validation email
      const email = document.getElementById('email').value.trim();
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (email && !emailPattern.test(email)) {
        isValid = false;
        errors.push('L\'adresse email n\'est pas valide');
        document.getElementById('email').classList.add('field-invalid');
      }
      
      // Validation numéro de téléphone
      const numeroEmploye = document.getElementById('numeroEmploye').value.trim().replace(/\s/g, '');
      const numeroPattern = /^(\+261|0)[0-9]{9}$/;
      if (numeroEmploye && !numeroPattern.test(numeroEmploye)) {
        isValid = false;
        errors.push('Le numéro de téléphone doit suivre le format: 034 12 345 67 ou +261 34 12 345 67');
        document.getElementById('numeroEmploye').classList.add('field-invalid');
      }
      
      if (!isValid) {
        e.preventDefault();
        showValidationErrors(errors);
        return;
      }
      
      // Animation du bouton de soumission
      submitBtn.disabled = true;
      submitText.textContent = 'Enregistrement en cours...';
      submitBtn.innerHTML = `
        <svg class="animate-spin w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 2v4m0 12v4m8.485-8.485l-2.828 2.828M5.515 5.515L2.687 8.343M20 12h-4M8 12H4m13.314-5.657l-2.828 2.828m-8.485 8.485l-2.828-2.828"/>
        </svg>
        Enregistrement en cours...
      `;
    });

    // 8. Affichage des erreurs de validation
    function showValidationErrors(errors) {
      const validationDiv = document.getElementById('validationMessages');
      validationDiv.innerHTML = '';
      validationDiv.classList.remove('hidden');
      
      const errorContainer = document.createElement('div');
      errorContainer.className = 'bg-red-50 border border-red-200 rounded-lg p-4';
      
      const title = document.createElement('h3');
      title.className = 'text-red-800 font-semibold mb-2 flex items-center';
      title.innerHTML = `
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        Erreurs de validation
      `;
      
      const errorList = document.createElement('ul');
      errorList.className = 'text-red-700 text-sm space-y-1';
      
      errors.forEach(error => {
        const li = document.createElement('li');
        li.className = 'flex items-start';
        li.innerHTML = `
          <svg class="w-4 h-4 mr-2 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
          </svg>
          ${error}
        `;
        errorList.appendChild(li);
      });
      
      errorContainer.appendChild(title);
      errorContainer.appendChild(errorList);
      validationDiv.appendChild(errorContainer);
      
      // Faire défiler vers les erreurs
      validationDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // 9. Auto-complétion intelligente du numéro employé
    function generateEmployeeNumber() {
      const departement = document.getElementById('departement').value;
      if (!departement) return '';
      
      const prefixes = {
        'Informatique': 'INF',
        'Administration': 'ADM',
        'Comptabilité': 'CPT',
        'Ressources Humaines': 'RH',
        'Marketing': 'MKT',
        'Ventes': 'VEN',
        'Logistique': 'LOG',
        'Juridique': 'JUR'
      };
      
      const prefix = prefixes[departement] || 'EMP';
      const randomNum = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
      return `${prefix}${randomNum}`;
    }

    // 10. Suggestion automatique du numéro employé
    document.getElementById('departement').addEventListener('change', function() {
      const numeroField = document.getElementById('numeroEmploye');
      if (!numeroField.value.trim()) {
        numeroField.value = generateEmployeeNumber();
        updateProgress();
      }
    });

    // 11. Amélioration de l'accessibilité
    document.querySelectorAll('.form-input').forEach(input => {
      input.addEventListener('blur', function() {
        if (this.hasAttribute('required') && !this.value.trim()) {
          this.setAttribute('aria-invalid', 'true');
        } else {
          this.setAttribute('aria-invalid', 'false');
        }
      });
    });

    // 12. Auto-focus sur le premier champ
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('nom').focus();
      updateProgress();
    });

    // 13. Formatage automatique des noms (première lettre en majuscule)
    ['nom', 'prenom'].forEach(fieldId => {
      document.getElementById(fieldId).addEventListener('blur', function() {
        if (this.value.trim()) {
          this.value = this.value.trim()
            .toLowerCase()
            .split(' ')
            .map(word => word.charAt(0).toUpperCase() + word.slice(1))
            .join(' ');
        }
      });
    });

    // 14. Raccourcis clavier
    document.addEventListener('keydown', function(e) {
      // Ctrl+S pour sauvegarder
      if (e.ctrlKey && e.key === 's') {
        e.preventDefault();
        document.getElementById('personnelForm').dispatchEvent(new Event('submit'));
      }
      
      // Échap pour réinitialiser
      if (e.key === 'Escape') {
        document.querySelector('button[type="reset"]').click();
      }
    });

    // 15. Animation lors du reset
    document.querySelector('button[type="reset"]').addEventListener('click', function() {
      setTimeout(() => {
        document.getElementById('qrPreview').classList.add('hidden');
        document.getElementById('validationMessages').classList.add('hidden');
        document.querySelectorAll('.field-valid, .field-invalid').forEach(field => {
          field.classList.remove('field-valid', 'field-invalid');
        });
        updateProgress();
        document.getElementById('nom').focus();
      }, 100);
    });

    // 16. Fonction pour fermer les alertes
    function closeAlert(alertId) {
      const alert = document.getElementById(alertId);
      if (alert) {
        alert.style.display = 'none';
      }
    }

    // 17. Auto-hide alerts after 5 seconds
    setTimeout(() => {
      const successAlert = document.getElementById('success-alert');
      const errorAlert = document.getElementById('error-alert');
      if (successAlert) successAlert.style.display = 'none';
      if (errorAlert) errorAlert.style.display = 'none';
    }, 5000);
  </script>
</body>
</html>
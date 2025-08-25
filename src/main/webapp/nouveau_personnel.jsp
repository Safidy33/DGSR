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
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
        <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>

      <!-- Contenu principal -->
      <section class="max-w-4xl mx-auto">
        <div class="bg-white rounded-lg shadow-lg p-8">
          <!-- En-tête -->
          <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-900">Ajouter un Nouveau Personnel</h1>
            <a href="gerer_personnel.jsp" class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition">
              Retour à la liste
            </a>
          </div>

          <!-- Formulaire -->
          <form action="gerer-personnel" method="post" class="space-y-6">
            <input type="hidden" name="action" value="add">
            
            <!-- Informations personnelles -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="form-group">
                <label for="nom" class="block text-sm font-medium text-gray-700 mb-2">
                  Nom <span class="text-red-500">*</span>
                </label>
                <input type="text" id="nom" name="nom" required
                       class="form-input w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Entrez le nom">
              </div>
              
              <div class="form-group">
                <label for="prenom" class="block text-sm font-medium text-gray-700 mb-2">
                  Prénom <span class="text-red-500">*</span>
                </label>
                <input type="text" id="prenom" name="prenom" required
                       class="form-input w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Entrez le prénom">
              </div>
            </div>

            <!-- Informations professionnelles -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="form-group">
                <label for="numeroEmploye" class="block text-sm font-medium text-gray-700 mb-2">
                  Numéro Employé <span class="text-red-500">*</span>
                </label>
                <input type="text" id="numeroEmploye" name="numeroEmploye" required
                       class="form-input w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Ex: EMP001">
              </div>
              
              <div class="form-group">
                <label for="departement" class="block text-sm font-medium text-gray-700 mb-2">
                  Département <span class="text-red-500">*</span>
                </label>
                <select id="departement" name="departement" required
                        class="form-input w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                  <option value="">Sélectionner un département</option>
                  <option value="Informatique">Informatique</option>
                  <option value="Administration">Administration</option>
                  <option value="Comptabilité">Comptabilité</option>
                  <option value="Ressources Humaines">Ressources Humaines</option>
                  <option value="Marketing">Marketing</option>
                  <option value="Ventes">Ventes</option>
                  <option value="Logistique">Logistique</option>
                  <option value="Juridique">Juridique</option>
                </select>
              </div>
            </div>

            <!-- Contact -->
            <div class="form-group">
              <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                Email <span class="text-red-500">*</span>
              </label>
              <input type="email" id="email" name="email" required
                     class="form-input w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                     placeholder="exemple@email.com">
            </div>

            <!-- QR Code (optionnel) -->
            <div class="form-group">
              <label for="qrCode" class="block text-sm font-medium text-gray-700 mb-2">
                QR Code (optionnel)
              </label>
              <div class="flex items-center space-x-2">
                <input type="text" id="qrCode" name="qrCode"
                       class="form-input flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       placeholder="Code QR pour le pointage">
                <button type="button" id="generateQR" 
                        class="bg-green-500 text-white px-3 py-2 rounded-lg hover:bg-green-600 transition text-sm">
                  Générer
                </button>
              </div>
              <div id="qrPreview" class="mt-2 hidden">
                <img id="qrImage" alt="QR Code" class="border rounded-lg">
              </div>
            </div>

            <!-- Boutons d'action -->
            <div class="flex justify-end space-x-4 pt-6">
              <button type="reset" 
                      class="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 transition">
                Réinitialiser
              </button>
              <button type="submit" 
                      class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition">
                Enregistrer le personnel
              </button>
            </div>
          </form>
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

    // Validation du formulaire
    document.querySelector('form').addEventListener('submit', function(e) {
      const nom = document.getElementById('nom').value.trim();
      const prenom = document.getElementById('prenom').value.trim();
      const email = document.getElementById('email').value.trim();
      
      if (!nom || !prenom || !email) {
        e.preventDefault();
        alert('Veuillez remplir tous les champs obligatoires.');
      }
    });
  </script>

</body>
</html>

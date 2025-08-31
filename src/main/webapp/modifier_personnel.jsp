<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Personnel" %>
<%
    Personnel personnel = (Personnel) request.getAttribute("personnel");
    if (personnel == null) {
        response.sendRedirect("gerer-personnel");
        return;
    }
    
    String adminName = "Admin"; 
    if (session != null && session.getAttribute("email") != null) {
        adminName = (String) session.getAttribute("email");
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Personnel - Système de Gestion de Pointage</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
        .field-modified {
            border-color: #f59e0b !important;
            background-color: rgba(245, 158, 11, 0.05);
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
                <a href="gerer-personnel" class="nav-item active px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
                <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
                <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Rapport</a>
                <a href="#" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
            </nav>

            <!-- Contenu principal -->
            <section class="max-w-5xl mx-auto">
                <div class="bg-white rounded-xl shadow-xl p-8">
                    <!-- En-tête avec informations sur le personnel -->
                    <div class="mb-8">
                        <div class="flex justify-between items-start mb-6">
                            <div>
                                <h1 class="text-3xl font-bold text-gray-900 flex items-center mb-2">
                                    <svg class="w-8 h-8 text-amber-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                    </svg>
                                    Modifier le Personnel
                                </h1>
                                <p class="text-gray-600">
                                    Modification des informations de : 
                                    <span class="font-semibold text-blue-600"><%= personnel.getPrenom() %> <%= personnel.getNom() %></span>
                                    <span class="text-sm bg-gray-100 px-2 py-1 rounded ml-2">ID: <%= personnel.getId() %></span>
                                </p>
                            </div>
                            <a href="gerer-personnel" class="bg-gray-500 text-white px-6 py-3 rounded-lg hover:bg-gray-600 transition flex items-center">
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                                </svg>
                                Retour à la liste
                            </a>
                        </div>
                        
                        <!-- Indicateur de modifications -->
                        <div class="bg-amber-50 border border-amber-200 rounded-lg p-4 mb-6">
                            <div class="flex items-start">
                                <svg class="w-5 h-5 text-amber-600 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                                </svg>
                                <div>
                                    <h3 class="text-sm font-semibold text-amber-800 mb-1">Mode modification</h3>
                                    <p class="text-sm text-amber-700">
                                        Les champs modifiés seront surlignés en orange. 
                                        <span id="modificationCount" class="font-semibold">Aucune modification</span> détectée.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Formulaire avec sections organisées -->
                    <form action="gerer-personnel" method="post" class="space-y-8" id="personnelEditForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= personnel.getId() %>">
                        
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
                                       value="<%= personnel.getNom() %>"
                                       data-original="<%= personnel.getNom() %>"
                                       autocomplete="family-name">
                                <div class="tooltip absolute left-0 top-full mt-1 bg-gray-800 text-white text-xs px-2 py-1 rounded z-10">
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
                                       value="<%= personnel.getPrenom() %>"
                                       data-original="<%= personnel.getPrenom() %>"
                                       autocomplete="given-name">
                                <div class="tooltip absolute left-0 top-full mt-1 bg-gray-800 text-white text-xs px-2 py-1 rounded z-10">
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
                                    Numéro Employé <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <input type="text" id="numeroEmploye" name="numeroEmploye" required
                                           class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent pl-12"
                                           placeholder="Ex: EMP001"
                                           value="<%= personnel.getNumeroEmploye() %>"
                                           data-original="<%= personnel.getNumeroEmploye() %>"
                                           pattern="[A-Z]{3}[0-9]{3,6}"
                                           title="Format: 3 lettres suivies de 3-6 chiffres (ex: EMP001)">
                                    <svg class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/>
                                    </svg>
                                </div>
                                <small class="text-gray-500 text-xs mt-1 block">Numéro unique d'identification</small>
                            </div>
                            
                            <div class="form-group relative">
                                <label for="departement" class="block text-sm font-medium text-gray-700 mb-2">
                                    Département <span class="text-red-500">*</span>
                                </label>
                                <div class="relative">
                                    <select id="departement" name="departement" required
                                            class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent pl-12 appearance-none bg-white"
                                            data-original="<%= personnel.getDepartement() %>">
                                        <option value="">-- Sélectionner un département --</option>
                                        <option value="Informatique" <%= "Informatique".equals(personnel.getDepartement()) ? "selected" : "" %>>💻 Informatique</option>
                                        <option value="Administration" <%= "Administration".equals(personnel.getDepartement()) ? "selected" : "" %>>🏢 Administration</option>
                                        <option value="Comptabilité" <%= "Comptabilité".equals(personnel.getDepartement()) ? "selected" : "" %>>📊 Comptabilité</option>
                                        <option value="Ressources Humaines" <%= "Ressources Humaines".equals(personnel.getDepartement()) ? "selected" : "" %>>👥 Ressources Humaines</option>
                                        <option value="Marketing" <%= "Marketing".equals(personnel.getDepartement()) ? "selected" : "" %>>📢 Marketing</option>
                                        <option value="Ventes" <%= "Ventes".equals(personnel.getDepartement()) ? "selected" : "" %>>💼 Ventes</option>
                                        <option value="Logistique" <%= "Logistique".equals(personnel.getDepartement()) ? "selected" : "" %>>🚚 Logistique</option>
                                        <option value="Juridique" <%= "Juridique".equals(personnel.getDepartement()) ? "selected" : "" %>>⚖️ Juridique</option>
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
                                           value="<%= personnel.getEmail() %>"
                                           data-original="<%= personnel.getEmail() %>"
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
                                Code QR pour Pointage
                            </h2>
                        </div>
                        
                        <div class="pl-6">
                            <div class="form-group">
                                <label for="qrCode" class="block text-sm font-medium text-gray-700 mb-2">
                                    Contenu du QR Code
                                </label>
                                <div class="flex flex-col lg:flex-row lg:items-start space-y-4 lg:space-y-0 lg:space-x-6">
                                    <div class="flex-1">
                                        <div class="flex items-center space-x-3 mb-4">
                                            <input type="text" id="qrCode" name="qrCode"
                                                   class="form-input flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                                   placeholder="Code QR pour le pointage"
                                                   value="<%= personnel.getQrCode() != null ? personnel.getQrCode() : "" %>"
                                                   data-original="<%= personnel.getQrCode() != null ? personnel.getQrCode() : "" %>">
                                            <button type="button" id="generateQR" 
                                                    class="bg-green-500 text-white px-4 py-3 rounded-lg hover:bg-green-600 transition flex items-center">
                                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                                                </svg>
                                                Actualiser
                                            </button>
                                            <button type="button" id="autoGenerateQR" 
                                                    class="bg-blue-500 text-white px-4 py-3 rounded-lg hover:bg-blue-600 transition flex items-center">
                                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                                                </svg>
                                                Régénérer
                                            </button>
                                        </div>
                                        
                                        <% if (personnel.getQrCode() != null && !personnel.getQrCode().isEmpty()) { %>
                                        <div class="bg-blue-50 border border-blue-200 rounded-lg p-3">
                                            <p class="text-sm text-blue-800 mb-1 font-medium">QR Code actuel :</p>
                                            <p class="text-sm text-blue-600 font-mono break-all"><%= personnel.getQrCode() %></p>
                                        </div>
                                        <% } %>
                                    </div>
                                    
                                    <div id="qrPreview" class="bg-gray-50 p-4 rounded-lg border-2 border-dashed border-gray-300 <%= personnel.getQrCode() != null && !personnel.getQrCode().isEmpty() ? "" : "hidden" %>">
                                        <p class="text-sm text-gray-600 mb-2 text-center">Aperçu du QR Code</p>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <!-- Messages de validation -->
                        <div id="validationMessages" class="hidden pl-6"></div>

                        <!-- Boutons d'action -->
                        <div class="border-t pt-6">
                            <div class="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
                                <div class="text-sm text-gray-600">
                                    <span class="flex items-center">
                                        <svg class="w-4 h-4 text-blue-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        Dernière modification : <%= new java.text.SimpleDateFormat("dd/MM/yyyy à HH:mm").format(new java.util.Date()) %>
                                    </span>
                                </div>
                                
                                <div class="flex space-x-4">
                                    <button type="button" id="resetBtn"
                                            class="bg-gray-500 text-white px-8 py-3 rounded-lg hover:bg-gray-600 transition flex items-center">
                                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                                        </svg>
                                        Annuler les modifications
                                    </button>
                                    <button type="submit" id="submitBtn"
                                            class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition flex items-center disabled:opacity-50 disabled:cursor-not-allowed">
                                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3 3m0 0l-3-3m3 3V4"/>
                                        </svg>
                                        <span id="submitText">Enregistrer les modifications</span>
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

        // ===== FONCTIONNALITÉS SPÉCIFIQUES À LA MODIFICATION =====
        
        const formFields = ['nom', 'prenom', 'numeroEmploye', 'departement', 'email', 'qrCode'];
        let originalValues = {};
        let modifiedFields = new Set();

        // 1. Stockage des valeurs originales
        document.addEventListener('DOMContentLoaded', function() {
            formFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field) {
                    originalValues[fieldId] = field.dataset.original || field.value;
                }
            });
            
            // Génération initiale du QR Code si existant
            const qrCode = document.getElementById('qrCode').value;
            if (qrCode) {
                generateQRCode(qrCode);
            }
        });

        // 2. Détection des modifications en temps réel
        function checkModifications() {
            modifiedFields.clear();
            let hasModifications = false;
            
            formFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field) {
                    const currentValue = field.value.trim();
                    const originalValue = (originalValues[fieldId] || '').trim();
                    
                    if (currentValue !== originalValue) {
                        modifiedFields.add(fieldId);
                        field.classList.add('field-modified');
                        hasModifications = true;
                    } else {
                        field.classList.remove('field-modified');
                    }
                }
            });
            
            updateModificationIndicator(hasModifications);
            return hasModifications;
        }

        // 3. Mise à jour de l'indicateur de modifications
        function updateModificationIndicator(hasModifications) {
            const modificationCount = document.getElementById('modificationCount');
            const modificationsSummary = document.getElementById('modificationsSummary');
            const modificationsList = document.getElementById('modificationsList');
            const submitBtn = document.getElementById('submitBtn');
            
            if (hasModifications) {
                const count = modifiedFields.size;
                modificationCount.textContent = `${count} modification${count > 1 ? 's' : ''} en cours`;
                modificationCount.className = 'font-semibold text-orange-600';
                
                // Afficher le résumé des modifications
                modificationsSummary.classList.remove('hidden');
                modificationsList.innerHTML = '';
                
                const fieldLabels = {
                    'nom': 'Nom',
                    'prenom': 'Prénom', 
                    'numeroEmploye': 'Numéro Employé',
                    'departement': 'Département',
                    'email': 'Email',
                    'qrCode': 'QR Code'
                };
                
                modifiedFields.forEach(fieldId => {
                    const field = document.getElementById(fieldId);
                    const label = fieldLabels[fieldId] || fieldId;
                    const originalValue = originalValues[fieldId] || '';
                    const currentValue = field.value.trim();
                    
                    const modDiv = document.createElement('div');
                    modDiv.className = 'mb-2 p-2 bg-white rounded border-l-3 border-orange-400';
                    modDiv.innerHTML = `
                        <span class="font-medium">${label}:</span><br>
                        <span class="text-gray-500 line-through">${originalValue || '(vide)'}</span> → 
                        <span class="text-orange-600 font-medium">${currentValue || '(vide)'}</span>
                    `;
                    modificationsList.appendChild(modDiv);
                });
                
                submitBtn.classList.remove('bg-blue-600', 'hover:bg-blue-700');
                submitBtn.classList.add('bg-orange-500', 'hover:bg-orange-600');
                
            } else {
                modificationCount.textContent = 'Aucune modification';
                modificationCount.className = 'font-semibold text-gray-600';
                modificationsSummary.classList.add('hidden');
                
                submitBtn.classList.remove('bg-orange-500', 'hover:bg-orange-600');
                submitBtn.classList.add('bg-blue-600', 'hover:bg-blue-700');
            }
        }

        // 4. Écouteurs pour la détection des modifications
        formFields.forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (field) {
                field.addEventListener('input', checkModifications);
                field.addEventListener('change', checkModifications);
            }
        });

        // 5. Génération QR Code améliorée
        function generateQRCode(text) {
            const qrPreview = document.getElementById('qrPreview');
            qrPreview.innerHTML = "";
            qrPreview.classList.remove('hidden');

            new QRCode(qrPreview, {
                text: text,
                width: 150,
                height: 150,
                colorDark: "#1e40af",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.M
            });
            
            const textDiv = document.createElement('div');
            textDiv.className = 'text-xs text-gray-600 mt-2 text-center break-all';
            textDiv.textContent = text;
            qrPreview.appendChild(textDiv);
        }

        // 6. Gestion des boutons QR Code
        document.getElementById('generateQR').addEventListener('click', () => {
            const qrText = document.getElementById('qrCode').value.trim();
            if (!qrText) {
                alert('Veuillez entrer un texte pour générer le QR Code.');
                return;
            }
            generateQRCode(qrText);
        });

        document.getElementById('autoGenerateQR').addEventListener('click', function() {
            const nom = document.getElementById('nom').value.trim();
            const prenom = document.getElementById('prenom').value.trim();
            const numeroEmploye = document.getElementById('numeroEmploye').value.trim();
            
            if (!nom || !prenom || !numeroEmploye) {
                alert('Veuillez remplir le nom, prénom et numéro employé avant la génération automatique.');
                return;
            }
            
            const qrData = `${numeroEmploye}-${nom}-${prenom}`;
            document.getElementById('qrCode').value = qrData;
            generateQRCode(qrData);
            checkModifications();
        });

        // 7. Tooltips interactives
        document.querySelectorAll('.form-group').forEach(group => {
            const input = group.querySelector('input, select');
            const tooltip = group.querySelector('.tooltip');
            
            if (input && tooltip) {
                input.addEventListener('mouseenter', () => tooltip.classList.add('show'));
                input.addEventListener('mouseleave', () => tooltip.classList.remove('show'));
                input.addEventListener('focus', () => tooltip.classList.add('show'));
                input.addEventListener('blur', () => tooltip.classList.remove('show'));
            }
        });

        // 8. Validation du formulaire
        document.getElementById('personnelEditForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const submitText = document.getElementById('submitText');
            
            // Vérifier s'il y a des modifications
            if (!checkModifications()) {
                e.preventDefault();
                alert('Aucune modification détectée. Veuillez apporter des changements avant de sauvegarder.');
                return;
            }
            
            // Validation des champs obligatoires
            let isValid = true;
            const errors = [];
            
            const requiredFields = ['nom', 'prenom', 'numeroEmploye', 'departement', 'email'];
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
            
            // Validation numéro employé
            const numeroEmploye = document.getElementById('numeroEmploye').value.trim();
            const numeroPattern = /^[A-Z]{3}[0-9]{3,6}$/;
            if (numeroEmploye && !numeroPattern.test(numeroEmploye)) {
                isValid = false;
                errors.push('Le numéro employé doit suivre le format: 3 lettres + 3-6 chiffres (ex: EMP001)');
                document.getElementById('numeroEmploye').classList.add('field-invalid');
            }
            
            if (!isValid) {
                e.preventDefault();
                showValidationErrors(errors);
                return;
            }
            
            // Confirmation des modifications importantes
            if (modifiedFields.has('numeroEmploye') || modifiedFields.has('email')) {
                if (!confirm('Vous modifiez des informations critiques (numéro employé ou email). Êtes-vous sûr de vouloir continuer ?')) {
                    e.preventDefault();
                    return;
                }
            }
            
            // Animation du bouton de soumission
            submitBtn.disabled = true;
            submitText.textContent = 'Mise à jour en cours...';
            submitBtn.innerHTML = `
                <svg class="animate-spin w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 2v4m0 12v4m8.485-8.485l-2.828 2.828M5.515 5.515L2.687 8.343M20 12h-4M8 12H4m13.314-5.657l-2.828 2.828m-8.485 8.485l-2.828-2.828"/>
                </svg>
                Mise à jour en cours...
            `;
        });

        // 9. Affichage des erreurs de validation
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
            
            validationDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        // 10. Bouton de reset intelligent
        document.getElementById('resetBtn').addEventListener('click', function() {
            if (checkModifications()) {
                if (confirm('Êtes-vous sûr de vouloir annuler toutes les modifications ?')) {
                    resetToOriginalValues();
                }
            }
        });

        function resetToOriginalValues() {
            formFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (field && originalValues[fieldId] !== undefined) {
                    field.value = originalValues[fieldId];
                    field.classList.remove('field-modified', 'field-invalid', 'field-valid');
                }
            });
            
            // Réinitialiser le QR Code
            const originalQR = originalValues['qrCode'];
            if (originalQR) {
                generateQRCode(originalQR);
            } else {
                document.getElementById('qrPreview').classList.add('hidden');
            }
            
            checkModifications();
            document.getElementById('validationMessages').classList.add('hidden');
        }

        // 11. Validation en temps réel du numéro employé
        document.getElementById('numeroEmploye').addEventListener('input', function(e) {
            const value = e.target.value.toUpperCase();
            e.target.value = value;
            
            const pattern = /^[A-Z]{3}[0-9]{3,6}$/;
            if (value && !pattern.test(value)) {
                e.target.classList.add('field-invalid');
                e.target.classList.remove('field-valid');
            } else if (value) {
                e.target.classList.add('field-valid');
                e.target.classList.remove('field-invalid');
            }
        });

        // 12. Formatage automatique des noms
        ['nom', 'prenom'].forEach(fieldId => {
            document.getElementById(fieldId).addEventListener('blur', function() {
                if (this.value.trim()) {
                    this.value = this.value.trim()
                        .toLowerCase()
                        .split(' ')
                        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
                        .join(' ');
                    checkModifications();
                }
            });
        });

        // 13. Raccourcis clavier spécifiques à la modification
        document.addEventListener('keydown', function(e) {
            // Ctrl+S pour sauvegarder
            if (e.ctrlKey && e.key === 's') {
                e.preventDefault();
                if (checkModifications()) {
                    document.getElementById('personnelEditForm').dispatchEvent(new Event('submit'));
                } else {
                    alert('Aucune modification à sauvegarder.');
                }
            }
            
            // Ctrl+Z pour annuler les modifications
            if (e.ctrlKey && e.key === 'z') {
                e.preventDefault();
                resetToOriginalValues();
            }
            
            // Échap pour retourner à la liste
            if (e.key === 'Escape') {
                if (checkModifications()) {
                    if (confirm('Vous avez des modifications non sauvegardées. Voulez-vous vraiment quitter ?')) {
                        window.location.href = 'gerer-personnel';
                    }
                } else {
                    window.location.href = 'gerer-personnel';
                }
            }
        });

        // 14. Avertissement avant de quitter la page
        window.addEventListener('beforeunload', function(e) {
            if (checkModifications()) {
                e.preventDefault();
                e.returnValue = 'Vous avez des modifications non sauvegardées. Êtes-vous sûr de vouloir quitter ?';
                return e.returnValue;
            }
        });

        // 15. Auto-focus et vérification initiale
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('nom').focus();
            setTimeout(checkModifications, 100);
        });

        // 16. Amélioration de l'accessibilité
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.hasAttribute('required') && !this.value.trim()) {
                    this.setAttribute('aria-invalid', 'true');
                } else {
                    this.setAttribute('aria-invalid', 'false');
                }
            });
        });

        // 17. Navigation via liens avec confirmation
        document.querySelectorAll('a[href]').forEach(link => {
            link.addEventListener('click', function(e) {
                if (this.href.includes('gerer-personnel') && checkModifications()) {
                    e.preventDefault();
                    if (confirm('Vous avez des modifications non sauvegardées. Voulez-vous vraiment quitter sans sauvegarder ?')) {
                        window.location.href = this.href;
                    }
                }
            });
        });
    </script>
</body>
</html>
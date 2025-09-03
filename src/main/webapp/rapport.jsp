<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="models.Pointage" %>
<%
String adminName = "Admin";
if (session != null && session.getAttribute("email") != null) {
    adminName = (String) session.getAttribute("email");
}

List<String> tousDepartements = (List<String>) request.getAttribute("tousDepartements");
Map<String, List<Map<String, Object>>> statutsPersonnels = (Map<String, List<Map<String, Object>>>) request.getAttribute("statutsPersonnels");
String dateDebut = (String) request.getAttribute("dateDebut");
if (dateDebut == null) dateDebut = "";
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Rapport - Système de Gestion de Pointage</title>
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

    /* Styles généraux */
        .present {
            background-color: #d1fae5;
            color: #065f46;
            padding: 3px 8px;
            border-radius: 9999px;
            font-weight: 500;
        }
        
        .absent {
            background-color: #fee2e2;
            color: #991b1b;
            padding: 3px 8px;
            border-radius: 9999px;
            font-weight: 500;
        }

        /* Styles titres sections */
        .section-title {
            text-align: center;
            font-weight: bold;
            margin-bottom: 1.5rem;
        }

        /* CSS d'impression professionnel optimisé */
        @media print {
            * {
                -webkit-print-color-adjust: exact !important;
                color-adjust: exact !important;
                print-color-adjust: exact !important;
            }
            
            .no-print {
                display: none !important;
            }
            
            @page {
                margin: 2cm 1.5cm;
                size: A4 portrait;
            }
            
            /* En-tête officiel du document */
            .print-header {
                display: block !important;
                page-break-after: avoid;
                margin-bottom: 25px;
            }
            
            .official-header {
                text-align: center;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 3px double #000;
            }
            
            /* Logo dans l'en-tête d'impression */
            .print-logo {
                display: none;
            }
            
            @media print {
                .print-logo {
                    display: block !important;
                    text-align: center;
                    margin: 15px 0;
                }
                
                .print-logo img {
                    width: 60px;
                    height: 60px;
                    object-fit: contain;
                    margin: 0 auto;
                }
            }
            
            .ministry-name {
                font-weight: bold;
                font-size: 14px;
                line-height: 1.2;
                margin: 2px 0;
                letter-spacing: 0.5px;
            }
            
            .department-info {
                font-size: 12px;
                font-weight: 600;
                margin: 3px 0;
                color: #333;
            }
            
            .location-date {
                text-align: right;
                margin: 15px 0;
                font-size: 12px;
                font-style: italic;
            }
            
            .document-title {
                text-align: center;
                font-size: 16px;
                font-weight: bold;
                text-decoration: underline;
                margin: 20px 0;
                letter-spacing: 1px;
            }
            
            /* Corps du document */
            body {
                font-family: 'Times New Roman', serif;
                font-size: 11px;
                line-height: 1.4;
                color: #000;
                background: white;
                margin: 0;
                padding: 0;
            }
            
            /* Titres */
            h1 {
                font-size: 18px;
                font-weight: bold;
                margin: 20px 0;
                text-align: center;
                page-break-after: avoid;
                color: #1a365d;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            
            h2.section-title {
                font-size: 15px;
                font-weight: bold;
                text-align: center;
                margin: 30px 0 20px 0;
                padding: 8px 0;
                background: linear-gradient(to right, #f7fafc, #e2e8f0, #f7fafc);
                border-top: 2px solid #2d3748;
                border-bottom: 2px solid #2d3748;
                page-break-after: avoid;
                color: #2d3748;
            }
            
            h3 {
                font-size: 13px;
                font-weight: bold;
                margin: 20px 0 12px 0;
                page-break-after: avoid;
                color: #2c5282;
                padding: 5px 0;
                border-bottom: 1px solid #cbd5e0;
            }
            
            /* Sections départementales */
            .department-section {
                page-break-inside: avoid;
                margin-bottom: 25px;
                break-inside: avoid;
                border: 1px solid #e2e8f0;
                padding: 15px;
                border-radius: 5px;
            }
            
            .department-header {
                margin-bottom: 15px;
                padding-bottom: 8px;
                border-bottom: 1px solid #cbd5e0;
            }
            
            .department-count {
                font-size: 10px;
                background: #f7fafc;
                border: 1px solid #cbd5e0;
                padding: 3px 8px;
                border-radius: 3px;
                float: right;
                margin-top: 2px;
            }
            
            /* Tableaux */
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 15px 0;
                font-size: 10px;
                background: white;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }
            
            /* En-têtes de tableaux */
            thead th {
                background: linear-gradient(to bottom, #4a5568, #2d3748) !important;
                color: white !important;
                border: 1px solid #1a202c;
                padding: 8px 6px;
                text-align: center;
                font-weight: bold;
                font-size: 10px;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }
            
            /* Cellules du corps */
            tbody td {
                border: 1px solid #cbd5e0;
                padding: 6px 4px;
                text-align: center;
                font-size: 9px;
                vertical-align: middle;
                background: white;
            }
            
            /* Alternance des lignes */
            tbody tr:nth-child(even) td {
                background: #f8fafc !important;
            }
            
            tbody tr:hover td {
                background: #edf2f7 !important;
            }
            
            /* Badges de statut */
            .present {
                background: linear-gradient(135deg, #d4edda, #c3e6cb) !important;
                color: #155724 !important;
                padding: 3px 6px;
                border-radius: 4px;
                font-weight: bold;
                font-size: 8px;
                border: 1px solid #c3e6cb;
                text-transform: uppercase;
                letter-spacing: 0.3px;
            }
            
            .absent {
                background: linear-gradient(135deg, #f8d7da, #f5c6cb) !important;
                color: #721c24 !important;
                padding: 3px 6px;
                border-radius: 4px;
                font-weight: bold;
                font-size: 8px;
                border: 1px solid #f5c6cb;
                text-transform: uppercase;
                letter-spacing: 0.3px;
            }
            
            /* Optimisation pour les grands tableaux */
            .large-table {
                font-size: 8px !important;
            }
            
            .large-table th {
                padding: 5px 3px !important;
                font-size: 8px !important;
            }
            
            .large-table td {
                padding: 4px 2px !important;
                font-size: 7px !important;
            }
            
            /* Informations de date */
            .print-date-info .print-only {
                display: block !important;
                font-weight: bold;
                margin: 15px 0;
                text-align: center;
                font-size: 12px;
                padding: 8px;
                background: #f8fafc;
                border: 1px solid #cbd5e0;
                border-radius: 5px;
            }
            
            /* Pied de page automatique */
            .print-footer {
                position: fixed;
                bottom: 1cm;
                left: 0;
                right: 0;
                text-align: center;
                font-size: 9px;
                color: #666;
                border-top: 1px solid #ccc;
                padding-top: 5px;
            }
            
            /* Numérotation des pages */
            @page {
                @bottom-center {
                    content: "Page " counter(page) " sur " counter(pages);
                    font-size: 9px;
                    color: #666;
                }
                
                @top-right {
                    content: "Confidentiel - Direction Générale de la Sécurité Routière";
                    font-size: 8px;
                    color: #999;
                    font-style: italic;
                }
            }
            
            /* Éviter les coupures de page indésirables */
            .department-section {
                break-inside: avoid-page;
            }
            
            thead {
                display: table-header-group;
            }
            
            tbody {
                display: table-row-group;
            }
            
            tr {
                page-break-inside: avoid;
            }
            
            /* Marges et espacement optimisés */
            .print-section {
                margin-bottom: 20px !important;
                box-shadow: none !important;
                border: none !important;
            }
            
            /* Style pour les cellules de noms */
            td:nth-child(2), td:nth-child(3) {
                text-align: left !important;
                padding-left: 8px !important;
            }
            
            /* Style pour les numéros de ligne */
            td:nth-child(1) {
                font-weight: 600;
                background: #f1f5f9 !important;
                color: #475569;
            }
            
            /* Amélioration de la lisibilité */
            table {
                border: 2px solid #2d3748;
            }
            
            /* Signature et validation */
            .signature-section {
                margin-top: 40px;
                display: flex;
                justify-content: space-between;
                page-break-inside: avoid;
            }
            
            .signature-box {
                width: 45%;
                text-align: center;
                border-top: 1px solid #000;
                padding-top: 8px;
                margin-top: 30px;
                font-size: 10px;
                font-weight: bold;
            }
        }
        
        /* Ajout d'une section de signature pour l'impression */
        .print-signature {
            display: none;
        }
        
        @media print {
            .print-signature {
                display: block !important;
                margin-top: 40px;
                page-break-inside: avoid;
            }
            
            .signature-container {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
            }
            
            .signature-left, .signature-right {
                width: 45%;
                text-align: center;
            }
            
            .signature-line {
                border-top: 1px solid #000;
                margin-top: 40px;
                padding-top: 5px;
                font-size: 10px;
                font-weight: bold;
            }
            
            .validation-info {
                margin-top: 25px;
                font-size: 9px;
                text-align: center;
                color: #666;
                font-style: italic;
            }
        }
    </style>
</head>

<body class="bg-white font-sans text-gray-800 min-h-screen flex flex-col">
    <!-- HEADER -->
    <header class="bg-blue-900 text-white flex items-center justify-between px-6 py-3 select-none no-print">
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
            <span class="font-semibold"><%= adminName %></span>
            <a href="LogoutServlet" class="btn-deconnexion text-white font-bold px-6 py-2 rounded-xl shadow-lg hover:shadow-2xl transition">Déconnexion</a>
        </div>
    </header>

    <div class="flex flex-1 min-h-0">

        <jsp:include page="Menu_rapide.jsp" />

        <!-- MAIN CONTENT -->
        <main class="flex-1 overflow-auto p-6">
      <nav class="bg-blue-900 rounded-xl w-full max-w-4xl py-2 px-4 flex space-x-6 text-white font-semibold shadow-lg mb-8 no-print mx-auto justify-center">
        <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Tableau de Bord</a>
        <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Gérer Personnel</a>
        <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Pointage</a>
        <a href="RapportServlet" class="nav-item px-4 py-2 active rounded-lg cursor-pointer">Rapport</a>
        <a href="HeureDeTravailServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-800 hover:text-white transition">Heures de Travails</a>
      </nav>
        <!-- En-tête officiel (visible uniquement à l'impression) -->
        <div class="print-header no-print" style="display: none;">
            <div class="official-header">
                <div class="ministry-name">REPUBLIQUE MALAGASY</div>
                <div class="ministry-name">Fitiavana - Tanindrazana - Fandrosoana</div>
                <div style="margin: 10px 0;">_________________</div>
                
                <div class="department-info">MINISTÈRE DÉLÉGUÉ EN CHARGE DE LA GENDARMERIE NATIONALE</div>
                <div class="department-info">SECRÉTARIAT GÉNÉRAL</div>
                <div class="department-info">DIRECTION GÉNÉRALE DE LA SÉCURITÉ ROUTIÈRE</div>
                
                <!-- Logo officiel pour l'impression -->
                <div class="print-logo">
                    <img src="assets/img/logo_dgsr.png" alt="Logo DGSR" />
                </div>
                
                <div style="margin: 10px 0;">
                    <div>Alarobia – BP 784</div>
                    <div>ANTANANARIVO</div>
                </div>
                
                <div style="margin: 15px 0; font-style: italic;">« LAHITOKANA NY AINA »</div>
            </div>
            
            <div class="location-date">
                <% 
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy", java.util.Locale.FRENCH);
                String dateActuelle = sdf.format(new java.util.Date()).toUpperCase();
                %>
                Antananarivo, le <%= dateActuelle %>
            </div>
            
            <div class="document-title">RAPPORT DE POINTAGE PAR DÉPARTEMENT</div>
            
            <!-- Informations de la date pour l'impression -->
            <% if (dateDebut != null && !dateDebut.isEmpty()) { %>
            <div class="print-only" style="margin: 15px 0; text-align: center; font-weight: bold; font-size: 12px;">
                Date du rapport : <%= dateDebut %>
            </div>
            <% } %>
        </div>

        <!-- Filtres -->
        <div class="bg-white rounded-lg shadow p-6 mb-8 no-print">
            <h2 class="text-xl font-bold text-gray-800 mb-6">Filtres</h2>
            <form action="RapportServlet" method="get" class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <input type="hidden" name="action" value="generer_rapport">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Date</label>
                    <input type="date" name="date_debut" value="<%= dateDebut %>" 
                           class="w-full p-3 border border-gray-300 rounded-lg">
                </div>
                <div class="flex items-end space-x-4">
                    <button type="submit" class="px-6 py-3 bg-blue-600 text-white rounded-lg font-semibold">
                        Générer Rapport
                    </button>
                    <button type="button" onclick="imprimerRapport()" 
                            class="px-6 py-3 bg-green-600 text-white rounded-lg font-semibold">
                        Imprimer
                    </button>
                </div>
            </form>
        </div>

        <!-- Tableau des pointages détaillés -->
        <% 
        List<Pointage> pointages = (List<Pointage>) request.getAttribute("pointages");
        if (pointages != null && !pointages.isEmpty()) { 
        %>
        <div class="bg-white rounded-lg shadow p-6 print-section mb-10">
            <h2 class="section-title text-2xl font-bold text-blue-700">📋 Tableau des Pointages Détaillés</h2>
            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left text-gray-900 <%= pointages.size() > 15 ? "large-table" : "" %>">
                    <thead class="text-xs uppercase text-gray-600 bg-gray-200">
                        <tr>
                            <th class="px-4 py-3 text-center">Date/Heure</th>
                            <th class="px-4 py-3 text-center">Type</th>
                            <th class="px-4 py-3 text-center">Nom du Personnel</th>
                            <th class="px-4 py-3 text-center">Département</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                        for (Pointage pointage : pointages) { 
                        %>
                        <tr class="border-b border-gray-200 hover:bg-gray-50">
                            <td class="px-4 py-3 text-center"><%= dateFormat.format(pointage.getDatePointage()) %></td>
                            <td class="px-4 py-3 text-center">
                                <span class="<%= "entree".equalsIgnoreCase(pointage.getType()) ? "present" : "absent" %>">
                                    <%= "entree".equalsIgnoreCase(pointage.getType()) ? "Entrée" : "Sortie" %>
                                </span>
                            </td>
                            <td class="px-4 py-3"><%= pointage.getNomPersonnel() + " " + pointage.getPrenomPersonnel() %></td>
                            <td class="px-4 py-3 text-center"><%= pointage.getDepartement() != null ? pointage.getDepartement() : "N/A" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>

        <!-- Tableaux des personnels par département -->
        <% if (statutsPersonnels != null && !statutsPersonnels.isEmpty()) { %>
        <div class="bg-white rounded-lg shadow p-6 print-section">
            <h2 class="section-title text-2xl font-bold text-green-700">👥 Tableau des Présences par Département</h2>
        </div>
        <% 
            for (Map.Entry<String, List<Map<String, Object>>> entry : statutsPersonnels.entrySet()) {
                String departement = entry.getKey();
                List<Map<String, Object>> personnelsDept = entry.getValue();
        %>
        <div class="bg-white rounded-lg shadow p-6 print-section department-section mb-10">
            <div class="department-header flex items-center justify-between mb-6">
                <h3 class="text-xl font-bold text-gray-800">🏢 Département: <%= departement %></h3>
                <div class="department-count border border-gray-400 rounded-lg px-3 py-1 text-sm font-semibold select-none">
                    👥 <%= personnelsDept.size() %> personnel(s)
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left text-gray-900 <%= personnelsDept.size() > 15 ? "large-table" : "" %>">
                    <thead class="text-xs uppercase text-gray-600 bg-gray-200">
                        <tr>
                            <th class="px-4 py-3 text-center">N°</th>
                            <th class="px-4 py-3 text-center">Nom du Personnel</th>
                            <th class="px-4 py-3 text-center">Matricule</th>
                            <th class="px-4 py-3 text-center">Statut du Jour</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        int numero = 1;
                        for (Map<String, Object> personnel : personnelsDept) {
                            String nomComplet = personnel.get("nom") + " " + personnel.get("prenom");
                            String matricule = (String) personnel.get("matricule");
                            String statut = (String) personnel.get("statut");
                        %>
                        <tr class="border-b border-gray-200 hover:bg-gray-50">
                            <td class="px-4 py-3 text-center"><%= numero++ %></td>
                            <td class="px-4 py-3"><%= nomComplet %></td>
                            <td class="px-4 py-3 text-center"><%= matricule != null ? matricule : "N/A" %></td>
                            <td class="px-4 py-3 text-center">
                                <span class="<%= "Présent".equals(statut) ? "present" : "absent" %>"><%= statut %></span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>
        <% } else { %>
        <div class="bg-gray-50 rounded-lg shadow p-6 text-center">
            <div class="text-gray-500 text-lg">Aucun pointage trouvé avec les filtres sélectionnés.</div>
        </div>
        <% } %>
        
        <!-- Section de signature (visible uniquement à l'impression) -->
        <div class="print-signature">
            <div class="validation-info">
                Document généré automatiquement par le système de gestion de pointage
            </div>
            <div class="signature-container">
                <div class="signature-left"></div>
                  	
                <div class="signature-right">
                    <div>Le Directeur Général</div>
                    <div class="signature-line">Nom et Signature</div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function imprimerRapport() {
            window.print();
        }

        const btnToggleSidebar = document.getElementById('btn-toggle-sidebar');
        const sidebar = document.getElementById('sidebar');
        btnToggleSidebar.addEventListener('click', () => {
          sidebar.classList.toggle('-translate-x-full');
        });
    </script>
</body>
</html>

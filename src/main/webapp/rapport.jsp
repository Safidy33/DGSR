<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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

        /* Styles d'impression optimisés */
        @media print {
            /* Masquer les éléments non nécessaires */
            .no-print {
                display: none !important;
            }
            
            /* Configuration de la page */
            @page {
                margin: 1.5cm 1cm 1cm 1cm;
                size: A4;
            }
            
            /* En-tête officiel pour l'impression */
            .print-header {
                display: block !important;
                text-align: center;
                margin-bottom: 30px;
                border-bottom: 2px solid #000;
                padding-bottom: 15px;
            }
            
            .official-header {
                font-size: 11px;
                line-height: 1.2;
                margin-bottom: 10px;
            }
            
            .ministry-name {
                font-weight: bold;
                text-transform: uppercase;
                margin-bottom: 5px;
            }
            
            .department-info {
                margin: 3px 0;
            }
            
            .location-date {
                text-align: right;
                font-size: 10px;
                margin: 10px 0;
            }
            
            .document-title {
                font-size: 16px;
                font-weight: bold;
                margin: 20px 0;
                text-decoration: underline;
            }
            
            /* Corps de la page */
            body {
                font-family: Arial, sans-serif;
                font-size: 12px;
                line-height: 1.3;
                color: #000;
                background: white;
                margin: 0;
                padding: 0;
            }
            
            /* Titre principal */
            h1 {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 20px;
                text-align: center;
                page-break-after: avoid;
            }
            
            /* Titres des départements */
            h3 {
                font-size: 14px;
                font-weight: bold;
                margin: 15px 0 10px 0;
                page-break-after: avoid;
            }
            
            /* Container des départements */
            .department-section {
                page-break-inside: avoid;
                margin-bottom: 20px;
                break-inside: avoid;
            }
            
            /* Forcer une nouvelle page avant certains départements si nécessaire */
            .department-section:nth-child(n+3) {
                page-break-before: auto;
            }
            
            /* En-tête des départements */
            .department-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                page-break-after: avoid;
            }
            
            .department-count {
                border: 1px solid #666;
                padding: 2px 6px;
                font-size: 10px;
                border-radius: 3px;
            }
            
            /* Tables */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 15px;
                page-break-inside: auto;
            }
            
            /* En-têtes de tableau */
            th {
                background-color: #f5f5f5 !important;
                border: 1px solid #333;
                padding: 6px 4px;
                text-align: center;
                font-weight: bold;
                font-size: 11px;
                page-break-after: avoid;
            }
            
            /* Cellules de tableau */
            td {
                border: 1px solid #666;
                padding: 4px;
                text-align: center;
                font-size: 10px;
                page-break-inside: avoid;
            }
            
            /* Lignes de tableau */
            tr {
                page-break-inside: avoid;
                page-break-after: auto;
            }
            
            /* Éviter la coupure après l'en-tête */
            thead {
                display: table-header-group;
            }
            
            tbody {
                display: table-row-group;
            }
            
            /* Statuts pour l'impression */
            .present {
                background-color: #e6ffe6 !important;
                color: #006600 !important;
                padding: 2px 4px;
                border-radius: 3px;
                font-weight: bold;
                font-size: 9px;
            }
            
            .absent {
                background-color: #ffe6e6 !important;
                color: #cc0000 !important;
                padding: 2px 4px;
                border-radius: 3px;
                font-weight: bold;
                font-size: 9px;
            }
            
            /* Assurer que les sections ne se chevauchent pas */
            .print-section {
                position: static;
                margin-bottom: 20px;
                page-break-inside: avoid;
            }
            
            /* Si un tableau est trop grand, permettre la coupure */
            .large-table {
                page-break-inside: auto;
            }
            
            .large-table tbody tr {
                page-break-inside: avoid;
            }
        }
        
        /* Styles d'écran */
        @media screen {
            .print-section {
                margin-bottom: 2rem;
            }
            
            .print-header {
                display: none;
            }
        }
    </style>
</head>

<body class="bg-white font-sans text-gray-800 min-h-screen">
    <!-- HEADER -->
    <header class="bg-blue-900 text-white flex items-center justify-between px-6 py-3 select-none no-print">
        <div class="flex items-center space-x-4">
            <img src="assets/img/logo_dgsr.png" alt="Logo DGS" class="w-14 h-14 object-cover"/>
            <div class="leading-tight font-semibold max-w-xs">
                <div>Système de Gestion</div>
                <div>de pointage</div>
            </div>
        </div>
        <div class="flex items-center space-x-4">
            <span class="font-semibold"><%= adminName %></span>
            <a href="LogoutServlet" class="px-4 py-2 bg-red-600 rounded-lg text-white font-bold">Déconnexion</a>
        </div>
    </header>

    <main class="p-6">
        <!-- En-tête officiel (visible uniquement à l'impression) -->
        <div class="print-header">
            <div class="official-header">
                <div class="ministry-name">REPUBLIQUE MALAGASY</div>
                <div class="ministry-name">Fitiavana - Tanindrazana - Fandrosoana</div>
                <div style="margin: 10px 0;">_________________</div>
                
                <div class="department-info">MINISTÈRE DÉLÉGUÉ EN CHARGE DE LA GENDARMERIE NATIONALE</div>
                <div class="department-info">SECRÉTARIAT GÉNÉRAL</div>
                <div class="department-info">DIRECTION GÉNÉRALE DE LA SÉCURITÉ ROUTIÈRE</div>
                
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
        </div>

        <h1 class="text-2xl font-bold mb-6 no-print">📊 Rapport de Pointage par Département</h1>
        
        <!-- Informations de la date pour l'impression -->
        <% if (dateDebut != null && !dateDebut.isEmpty()) { %>
        <div class="mb-4 text-center font-semibold print-date-info">
            <span class="no-print">Rapport du : <%= dateDebut %></span>
            <div style="display: none;" class="print-only">
                Date du rapport : <%= dateDebut %>
            </div>
        </div>
        <% } %>

        <style>
        @media print {
            .print-date-info .print-only {
                display: block !important;
                font-weight: bold;
                margin: 15px 0;
                text-align: center;
                font-size: 12px;
            }
        }
        </style>

        <!-- Formulaire de filtrage -->
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

        <!-- Tableaux des personnels par département -->
        <% if (statutsPersonnels != null && !statutsPersonnels.isEmpty()) { 
            for (Map.Entry<String, List<Map<String, Object>>> entry : statutsPersonnels.entrySet()) {
                String departement = entry.getKey();
                List<Map<String, Object>> personnelsDept = entry.getValue();
        %>
        <div class="bg-white rounded-lg shadow p-6 print-section department-section">
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
                            <th class="px-4 py-3 font-semibold text-center">N°</th>
                            <th class="px-4 py-3 font-semibold text-center">Nom du Personnel</th>
                            <th class="px-4 py-3 font-semibold text-center">Matricule</th>
                            <th class="px-4 py-3 font-semibold text-center">Statut du Jour</th>
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
                        <tr class="border-b border-gray-200">
                            <td class="px-4 py-3 text-center"><%= numero++ %></td>
                            <td class="px-4 py-3"><%= nomComplet %></td>
                            <td class="px-4 py-3 text-center"><%= matricule != null ? matricule : "N/A" %></td>
                            <td class="px-4 py-3 text-center">
                                <span class="<%= "Présent".equals(statut) ? "present" : "absent" %>">
                                    <%= statut %>
                                </span>
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
    </main>

    <script>
        function imprimerRapport() {
            // Préparer l'impression
            window.print();
        }

        // Événements d'impression
        window.addEventListener('beforeprint', () => {
            document.body.classList.add('printing');
        });

        window.addEventListener('afterprint', () => {
            document.body.classList.remove('printing');
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="models.Personnel" %>
<%
String adminName = "Admin";
if (session != null && session.getAttribute("email") != null) {
    adminName = (String) session.getAttribute("email");
}

List<Personnel> tousPersonnels = (List<Personnel>) request.getAttribute("tousPersonnels");
List<String> tousDepartements = (List<String>) request.getAttribute("tousDepartements");
Map<String, Object> statistiquesGlobales = (Map<String, Object>) request.getAttribute("statistiquesGlobales");
Map<String, Map<String, Object>> statistiquesParDepartement = (Map<String, Map<String, Object>>) request.getAttribute("statistiquesParDepartement");
Map<String, List<Map<String, Object>>> statutsPersonnels = (Map<String, List<Map<String, Object>>>) request.getAttribute("statutsPersonnels");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Statistiques - Système de Gestion de Pointage</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Scrollbar personnalisée */
        ::-webkit-scrollbar { 
            width: 8px; 
        }
        ::-webkit-scrollbar-track { 
            background: transparent; 
        }
        ::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, #fb5607, #ff8500);
            border-radius: 10px;
            border: 2px solid transparent;
            background-clip: content-box;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(180deg, #e04e00, #fb5607);
        }

        /* Bouton déconnexion */
        .btn-deconnexion {
            background: linear-gradient(135deg, #ff3e00, #bf2f00);
            box-shadow: 0 4px 15px rgba(255, 62, 0, 0.3);
            transition: all 0.3s ease;
        }
        .btn-deconnexion:hover {
            background: linear-gradient(135deg, #bf2f00, #ff3e00);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 62, 0, 0.4);
        }

        /* Navigation active */
        .nav-item.active {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white !important;
            font-weight: 600;
            border-radius: 0.5rem;
            box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
        }

        /* Titre principal avec animation */
        .main-title {
            font-size: 2.5rem;
            font-weight: 800;
            color: #1e40af;
            text-align: center;
            margin-bottom: 2rem;
            position: relative;
            background: linear-gradient(135deg, #1e40af, #3b82f6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: titleGlow 3s ease-in-out infinite alternate;
        }

        .main-title::before {
            content: "📊";
            position: absolute;
            left: -60px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 2rem;
            animation: iconBounce 2s ease-in-out infinite;
        }

        @keyframes titleGlow {
            0% { filter: brightness(1); }
            100% { filter: brightness(1.2) drop-shadow(0 0 20px rgba(59, 130, 246, 0.3)); }
        }

        @keyframes iconBounce {
            0%, 100% { transform: translateY(-50%) scale(1); }
            50% { transform: translateY(-50%) scale(1.1); }
        }

        /* Cards statistiques avec effets avancés */
        .stat-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border: 1px solid #e2e8f0;
            border-radius: 1.5rem;
            padding: 2rem;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.6), transparent);
            transition: left 0.6s;
        }

        .stat-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1), 0 10px 20px rgba(0, 0, 0, 0.05);
            border-color: #3b82f6;
        }

        .stat-card:hover::before {
            left: 100%;
        }

        /* Icônes des statistiques */
        .stat-icon {
            width: 4rem;
            height: 4rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.2);
        }

        .total-icon {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
        }
        .present-icon {
            background: linear-gradient(135deg, #10b981, #059669);
        }
        .absent-icon {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }

        /* Nombres statistiques */
        .stat-number {
            font-size: 3rem;
            font-weight: 900;
            background: linear-gradient(135deg, #1e293b, #475569);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-number {
            transform: scale(1.1);
        }

        .stat-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        /* Cartes de section */
        .section-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-radius: 1.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
            padding: 2rem;
            margin-bottom: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .section-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3b82f6, #1d4ed8, #1e40af);
            border-radius: 1.5rem 1.5rem 0 0;
        }

        .section-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
            border-color: #3b82f6;
        }

        /* Titres de section */
        .section-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1e40af;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        /* Tableaux améliorés */
        .enhanced-table {
            overflow: hidden;
            border-radius: 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .enhanced-table thead th {
            background: linear-gradient(135deg, #1e40af, #3b82f6);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem;
            font-size: 0.875rem;
        }

        .enhanced-table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #f1f5f9;
        }

        .enhanced-table tbody tr:hover {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            transform: scale(1.01);
        }

        .enhanced-table tbody td {
            padding: 1rem;
            font-weight: 500;
            color: #374151;
        }

        /* Cards département */
        .dept-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border: 2px solid #e2e8f0;
            border-radius: 1.25rem;
            padding: 1.5rem;
            text-align: center;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .dept-card::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.1) 0%, transparent 70%);
            transform: scale(0);
            transition: transform 0.6s ease;
        }

        .dept-card:hover {
            transform: translateY(-6px) scale(1.02);
            box-shadow: 0 15px 35px rgba(59, 130, 246, 0.15);
            border-color: #3b82f6;
        }

        .dept-card:hover::after {
            transform: scale(1);
        }

        .dept-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #1e40af;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }

        .dept-stats {
            position: relative;
            z-index: 1;
        }

        .dept-stat-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f1f5f9;
            transition: all 0.2s ease;
        }

        .dept-stat-item:last-child {
            border-bottom: none;
        }

        .dept-stat-item:hover {
            background: rgba(59, 130, 246, 0.05);
            border-radius: 0.5rem;
            padding-left: 0.75rem;
            padding-right: 0.75rem;
        }

        .dept-stat-label {
            color: #64748b;
            font-weight: 500;
        }

        .dept-stat-value {
            font-weight: 700;
            color: #1e293b;
            font-size: 1.125rem;
        }

        /* Animations d'entrée */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in-up {
            animation: fadeInUp 0.6s ease-out forwards;
        }

        .fade-in-up:nth-child(1) { animation-delay: 0.1s; }
        .fade-in-up:nth-child(2) { animation-delay: 0.2s; }
        .fade-in-up:nth-child(3) { animation-delay: 0.3s; }

        /* Responsive */
        @media (max-width: 768px) {
            .main-title {
                font-size: 2rem;
            }
            .main-title::before {
                left: -40px;
                font-size: 1.5rem;
            }
            .stat-number {
                font-size: 2.5rem;
            }
            .section-title {
                font-size: 1.5rem;
            }
        }

        @media (max-width: 640px) {
            .stat-card, .dept-card {
                padding: 1rem;
            }
            .section-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>

<body class="bg-gradient-to-br from-gray-50 to-blue-50 font-sans text-gray-800 min-h-screen flex flex-col">
    <!-- HEADER -->
    <header class="bg-gradient-to-r from-blue-900 to-blue-800 text-white flex items-center justify-between px-6 py-3 select-none shadow-lg">
        <div class="flex items-center space-x-4">
            <button id="btn-toggle-sidebar" aria-label="Toggle menu" class="md:hidden focus:outline-none">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                     class="w-8 h-8 text-white" viewBox="0 0 24 24">
                  <line x1="3" y1="6" x2="21" y2="6"></line>
                  <line x1="3" y1="12" x2="21" y2="12"></line>
                  <line x1="3" y1="18" x2="21" y2="18"></line>
                </svg>
            </button>

            <img src="assets/img/logo_dgsr.png" alt="Logo DGS" class="w-14 h-14 object-cover rounded-lg shadow-md"/>
            <div class="leading-tight font-semibold max-w-xs">
                <div>Système de Gestion</div>
                <div>de pointage</div>
            </div>
        </div>
        <div class="flex items-center space-x-4">
            <span class="font-semibold"><%= adminName %></span>
            <a href="LogoutServlet" class="btn-deconnexion text-white font-bold px-6 py-2 rounded-xl transition">Déconnexion</a>
        </div>
    </header>

    <div class="flex flex-1 min-h-0">
        <jsp:include page="Menu_rapide.jsp" />

        <!-- MAIN CONTENT -->
        <main class="flex-1 overflow-auto p-6">
            <nav class="bg-gradient-to-r from-blue-900 to-blue-800 rounded-xl w-full max-w-4xl py-3 px-6 flex space-x-6 text-white font-semibold shadow-xl mb-8 mx-auto justify-center">
                <a href="PointageServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-700 hover:text-white transition-all duration-300">Tableau de Bord</a>
                <a href="gerer-personnel" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-700 hover:text-white transition-all duration-300">Gérer Personnel</a>
                <a href="PointageServlet?action=pointage" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-700 hover:text-white transition-all duration-300">Pointage</a>
                <a href="RapportServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-700 hover:text-white transition-all duration-300">Rapport</a>
                <a href="HeureDeTravailServlet" class="nav-item px-4 py-2 rounded-lg cursor-pointer hover:bg-blue-700 hover:text-white transition-all duration-300">Heures de Travails</a>
            </nav>

            <h1 class="main-title">Statistiques du Système</h1>

            <!-- Statistiques Globales -->
            <% if (statistiquesGlobales != null) { %>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                <div class="stat-card fade-in-up">
                    <div class="stat-icon total-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                            <path d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
                        </svg>
                    </div>
                    <div class="stat-number"><%= statistiquesGlobales.get("totalPointages") %></div>
                    <div class="stat-label">Total Pointages</div>
                </div>
                
                <div class="stat-card fade-in-up">
                    <div class="stat-icon present-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                            <path d="M16 21v-2a4 4 0 00-4-4H9a4 4 0 00-4 4v2"/>
                            <circle cx="12.5" cy="7" r="4"/>
                            <path d="M20 8v6M23 11h-6"/>
                        </svg>
                    </div>
                    <div class="stat-number"><%= statistiquesGlobales.get("entrees") %></div>
                    <div class="stat-label">Entrées</div>
                </div>
                
                <div class="stat-card fade-in-up">
                    <div class="stat-icon absent-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                            <path d="M16 21v-2a4 4 0 00-4-4H9a4 4 0 00-4 4v2"/>
                            <circle cx="12.5" cy="7" r="4"/>
                            <path d="M18 8l5 5M23 8l-5 5"/>
                        </svg>
                    </div>
                    <div class="stat-number"><%= statistiquesGlobales.get("sorties") %></div>
                    <div class="stat-label">Sorties</div>
                </div>
            </div>
            <% } %>

            <!-- Statistiques par Personnel -->
            <% if (statistiquesGlobales != null && statistiquesGlobales.get("pointagesParPersonnel") != null) { %>
            <div class="section-card">
                <h2 class="section-title">
                    👤 Pointages par Personnel
                </h2>
                <div class="enhanced-table overflow-x-auto">
                    <table class="w-full">
                        <thead>
                            <tr>
                                <th class="text-left">Nom du Personnel</th>
                                <th class="text-center">Nombre de Pointages</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            @SuppressWarnings("unchecked")
                            Map<String, Integer> pointagesParPersonnel = (Map<String, Integer>) statistiquesGlobales.get("pointagesParPersonnel");
                            for (Map.Entry<String, Integer> entry : pointagesParPersonnel.entrySet()) {
                            %>
                            <tr>
                                <td><%= entry.getKey() %></td>
                                <td class="text-center font-bold"><%= entry.getValue() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } %>

            <!-- Statistiques par Département -->
            <% if (statistiquesParDepartement != null && !statistiquesParDepartement.isEmpty()) { %>
            <div class="section-card">
                <h2 class="section-title">
                    🏢 Statistiques par Département
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <%
                    for (Map.Entry<String, Map<String, Object>> entry : statistiquesParDepartement.entrySet()) {
                        String dept = entry.getKey();
                        Map<String, Object> stats = entry.getValue();
                    %>
                    <div class="dept-card">
                        <div class="stat-icon total-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-white" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
                                <path d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                            </svg>
                        </div>
                        <h3 class="dept-title"><%= dept %></h3>
                        <div class="dept-stats space-y-2">
                            <div class="dept-stat-item">
                                <span class="dept-stat-label">Total:</span>
                                <span class="dept-stat-value"><%= stats.get("total") %></span>
                            </div>
                            <div class="dept-stat-item">
                                <span class="dept-stat-label">Entrées:</span>
                                <span class="dept-stat-value text-green-600"><%= stats.get("entrees") %></span>
                            </div>
                            <div class="dept-stat-item">
                                <span class="dept-stat-label">Sorties:</span>
                                <span class="dept-stat-value text-red-600"><%= stats.get("sorties") %></span>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>
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

        // Animation d'apparition progressive
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.stat-card, .section-card, .dept-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'all 0.6s ease';
                    
                    setTimeout(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, 100);
                }, index * 100);
            });
        });
    </script>
</body>
</html>
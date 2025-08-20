<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Personnel" %>
<%
    Personnel personnel = (Personnel) request.getAttribute("personnel");
    if (personnel == null) {
        response.sendRedirect("gerer-personnel");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Personnel - Système de Gestion de Pointage</title>
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
    </style>
</head>
<body class="bg-gray-50 font-sans">
    <div class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8">
            <div>
                <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                    Modifier le Personnel
                </h2>
            </div>
            
            <form class="mt-8 space-y-6" action="gerer-personnel" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= personnel.getId() %>">
                
            <div class="rounded-md shadow-sm -space-y-px">
                    <div>
                        <label for="nom" class="sr-only">Nom</label>
                        <input id="nom" name="nom" type="text" required 
                               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                               placeholder="Nom" value="<%= personnel.getNom() %>">
                    </div>
                    
                    <div>
                        <label for="prenom" class="sr-only">Prénom</label>
                        <input id="prenom" name="prenom" type="text" required 
                               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                               placeholder="Prénom" value="<%= personnel.getPrenom() %>">
                    </div>
                    
                    <div>
                        <label for="numeroEmploye" class="sr-only">Numéro Employé</label>
                        <input id="numeroEmploye" name="numeroEmploye" type="text" required 
                               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                               placeholder="Numéro Employé" value="<%= personnel.getNumeroEmploye() %>">
                    </div>
                    
                    <div>
                        <label for="departement" class="sr-only">Département</label>
                        <select id="departement" name="departement" required 
                                class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm">
                            <option value="">Sélectionner un département</option>
                            <option value="Informatique" <%= "Informatique".equals(personnel.getDepartement()) ? "selected" : "" %>>Informatique</option>
                            <option value="Administration" <%= "Administration".equals(personnel.getDepartement()) ? "selected" : "" %>>Administration</option>
                            <option value="Comptabilité" <%= "Comptabilité".equals(personnel.getDepartement()) ? "selected" : "" %>>Comptabilité</option>
                        </select>
                    </div>
                    
                    <div>
                        <label for="email" class="sr-only">Email</label>
                        <input id="email" name="email" type="email" required 
                               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                               placeholder="Email" value="<%= personnel.getEmail() %>">
                    </div>
                    
                    <div>
                        <label for="qrCode" class="sr-only">QR Code</label>
                        <input id="qrCode" name="qrCode" type="text"
                               class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                               placeholder="QR Code" value="<%= personnel.getQrCode() != null ? personnel.getQrCode() : "" %>">
                    </div>
                </div>

                <div>
                    <button type="submit" 
                            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                        Enregistrer les modifications
                    </button>
                </div>
                
                <div>
                    <a href="gerer-personnel" 
                       class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-gray-700 bg-gray-300 hover:bg-gray-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500">
                        Annuler
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

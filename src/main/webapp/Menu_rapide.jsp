<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentPage = request.getParameter("currentPage");
    if (currentPage == null) currentPage = "";
%>
<!-- SIDEBAR -->
    <aside id="sidebar"
           class="fixed top-0 left-0 z-40 w-56 h-full bg-white border-r border-gray-200 py-6 overflow-y-auto
                  transform -translate-x-full transition-transform duration-300 ease-in-out
                  md:relative md:translate-x-0 md:flex md:flex-col">
      <h2 class="px-6 font-bold text-lg flex items-center justify-between mb-6 cursor-default">
        Menu Rapide
      </h2>
      <nav class="flex flex-col space-y-6 text-gray-700 px-6">
        <a href="nouveau_personnel.jsp" class="flex items-center space-x-3 hover:text-blue-600 transition">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          <span>Nouveau personnel</span>
        </a>
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-purple-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <span>Générer Rapport</span>
        </a>
        <a href="PointageServlet?action=voir_presents" class="flex items-center space-x-3 hover:text-blue-600 transition">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span>Voir Présents</span>
        </a>
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span>Voir Absents</span>
        </a>
        <a href="#" class="flex items-center space-x-3 hover:text-blue-600 transition">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-orange-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
          </svg>
          <span>Statistique</span>
        </a>
      </nav>
    </aside>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Connexion Administrateur</title>
<link rel="stylesheet" href="styles.css">
<style>
  .error-message {
      color: red;
      margin-bottom: 10px;
      text-align: center;
  }
</style>
</head>
<body>
  <header>
    <img src="assets/img/logo_dgsr.png" alt="Logo carré bleu et noir officiel de la Direction Générale Sécurité Routière"
        class="w-14 h-14 object-cover"/>
    <div class="title">
      <span>Système de Gestion</span>
      <span>de pointage</span>
    </div>
  </header>

  <main>
    <section class="login-box" aria-label="Formulaire de connexion administrateur">
      <h1>Connexion Administrateur</h1>

      <!-- Message d'erreur -->
      <%
          String error = request.getParameter("error");
          if ("1".equals(error)) {
      %>
          <div class="error-message">Email ou mot de passe incorrect ! ❌</div>
      <%
          }
      %>

      <form action="LoginServlet" method="post">
          <input type="email" name="email" placeholder="Email ..." aria-label="Adresse email" required />
          <input type="password" name="mot_de_passe" placeholder="Mot de passe ..." aria-label="Mot de passe" required />
          <button type="submit" aria-label="Se connecter">Connexion</button>
      </form>
      <a href="#" tabindex="0">Mot de passe oublié ?</a>
    </section>
  </main>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Connexion Administrateurs</title>
<link rel="stylesheet" href="styles.css">
<style>
@charset "UTF-8";
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  body, html {
    height: 100%;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #fff;
    color: #000;
  }

  /* Header with logo and title */
  header {
    background-color: #18375E; /* dark navy */
    height: 80px;
    display: flex;
    align-items: center;
    padding: 0 30px;
    gap: 20px;
  }

  header img {
    height: 60px;
    width: 60px;
    object-fit: contain;
  }

  header .title {
    color: #FFF;
    font-weight: 600;
    font-size: 18px;
    line-height: 1.2;
  }

  header .title span {
    display: block;
  }

  /* Center container for login */
  main {
    min-height: calc(100vh - 80px);
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .login-box {
    background-color: #F9FBFE;
    padding: 40px 45px 30px 45px;
    box-shadow: 0 0 18px rgba(0,0,0,0.07);
    border-radius: 6px;
    width: 454px;
    text-align: center;
  }

  .login-box h1 {
    font-weight: 700;
    font-size: 24px;
    margin-bottom: 30px;
    color: #000;
  }

  .login-box input[type="email"],
  .login-box input[type="password"] {
    width: 100%;
    background-color: #D3D3D3;
    border: none;
    border-radius: 15px;
    padding: 14px 15px;
    margin-bottom: 18px;
    font-size: 14px;
    color: #555;
    outline: none;
    transition: background-color 0.3s ease;
  }

  .login-box input[type="email"]::placeholder,
  .login-box input[type="password"]::placeholder {
    color: #666;
  }

  .login-box input[type="email"]:focus,
  .login-box input[type="password"]:focus {
    background-color: #c0c0c0;
  }

  .login-box button {
    width: 100%;
    background-color: #2E374B; /* dark blue/gray */
    color: white;
    border-radius: 15px;
    padding: 14px 0;
    font-weight: 700;
    font-size: 16px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  .login-box button:hover {
    background-color: #474F67;
  }

  .login-box a {
    display: inline-block;
    margin-top: 20px;
    color: #0d6efd; /* bootstrap blue */
    font-size: 13px;
    text-decoration: none;
  }

  .login-box a:hover,
  .login-box a:focus {
    text-decoration: underline;
  }

  /* Responsive */
  @media(max-width: 400px) {
    .login-box {
      width: 90vw;
      padding: 30px 25px;
    }
  }
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

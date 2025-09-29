# Utiliser l'image de base Tomcat 9.0
FROM tomcat:9.0

# Copier le fichier WAR dans le répertoire webapps de Tomcat
COPY dgsr.war /usr/local/tomcat/webapps/

# Exposer le port 8080 pour accéder à l'application
EXPOSE 8080

# Démarrer Tomcat
CMD ["catalina.sh", "run"]

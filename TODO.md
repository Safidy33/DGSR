# TODO - Création de la page statistique

## Étapes à suivre :
- [x] Créer le servlet StatistiqueServlet.java pour gérer la logique des statistiques
- [x] Créer la page JSP statistique.jsp pour afficher les statistiques
- [ ] Mettre à jour web.xml pour mapper le servlet /StatistiqueServlet
- [x] Ajouter un lien vers la page statistique dans le menu (optionnel)
- [ ] Tester la page statistique en accédant à /StatistiqueServlet

## Détails :
- Le servlet récupérera les données de pointage et de personnel depuis la base de données
- Il calculera les statistiques (total pointages, entrées/sorties, par personnel, par département)
- La page JSP affichera ces statistiques de manière claire et organisée
- Utiliser les méthodes similaires à RapportServlet pour la récupération des données

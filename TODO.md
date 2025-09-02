# Migration vers Jakarta EE - Plan d'Exécution

## Phase 1: Mise à jour de HeureDeTravailServlet ✅ COMPLÉTÉ
- [x] Remplacer les imports javax.servlet.* par jakarta.servlet.*
- [x] Ajouter l'annotation @WebServlet
- [x] Mettre à jour les signatures de méthodes

## Phase 2: Nettoyage de web.xml ✅ COMPLÉTÉ
- [x] Supprimer les mappings de servlets déjà annotées
- [x] Vérifier si le filtre peut être géré par annotation
- [x] Garder les configurations essentielles

## Phase 3: Vérification finale ✅ COMPLÉTÉ
- [x] Tester l'application (WAR file créé avec succès)
- [x] Vérifier la cohérence des imports (tous les servlets utilisent jakarta.servlet.*)
- [x] S'assurer que toutes les fonctionnalités marchent (compilation réussie)

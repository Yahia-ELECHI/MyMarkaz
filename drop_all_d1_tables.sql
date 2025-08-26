-- =========================================================
-- SCRIPT POUR VIDER TOUTES LES TABLES D1
-- À copier-coller dans la console Cloudflare D1
-- =========================================================

-- Suppression dans l'ordre inverse pour éviter les contraintes de clés étrangères

-- Tables École App - Relations
DROP TABLE IF EXISTS "ecole_app_reponse_choix_selectionnes";
DROP TABLE IF EXISTS "ecole_app_reponse";
DROP TABLE IF EXISTS "ecole_app_tentativequiz";
DROP TABLE IF EXISTS "ecole_app_noteexamen";
DROP TABLE IF EXISTS "ecole_app_question";
DROP TABLE IF EXISTS "ecole_app_choix";
DROP TABLE IF EXISTS "ecole_app_quiz";
DROP TABLE IF EXISTS "ecole_app_document";
DROP TABLE IF EXISTS "ecole_app_module_classes";
DROP TABLE IF EXISTS "ecole_app_module";
DROP TABLE IF EXISTS "ecole_app_courspartage_classes";
DROP TABLE IF EXISTS "ecole_app_courspartage";
DROP TABLE IF EXISTS "ecole_app_eleve_creneaux";
DROP TABLE IF EXISTS "ecole_app_eleve_classes";
DROP TABLE IF EXISTS "ecole_app_professeur_composantes";

-- Tables École App - Données pédagogiques
DROP TABLE IF EXISTS "ecole_app_revision";
DROP TABLE IF EXISTS "ecole_app_repetition";
DROP TABLE IF EXISTS "ecole_app_progressioncoran";
DROP TABLE IF EXISTS "ecole_app_presenceprofesseur";
DROP TABLE IF EXISTS "ecole_app_presenceeleve";
DROP TABLE IF EXISTS "ecole_app_paiementhistorique";
DROP TABLE IF EXISTS "ecole_app_paiement";
DROP TABLE IF EXISTS "ecole_app_objectifmensuel";
DROP TABLE IF EXISTS "ecole_app_memorisation";
DROP TABLE IF EXISTS "ecole_app_listeattente";
DROP TABLE IF EXISTS "ecole_app_evaluationcompetence";
DROP TABLE IF EXISTS "ecole_app_ecouteavantmemo";
DROP TABLE IF EXISTS "ecole_app_charge";
DROP TABLE IF EXISTS "ecole_app_carnetpedagogique";

-- Tables École App - Principales
DROP TABLE IF EXISTS "ecole_app_eleve";
DROP TABLE IF EXISTS "ecole_app_classe";
DROP TABLE IF EXISTS "ecole_app_professeur";
DROP TABLE IF EXISTS "ecole_app_creneau";
DROP TABLE IF EXISTS "ecole_app_anneescolaire";
DROP TABLE IF EXISTS "ecole_app_competencelivre";
DROP TABLE IF EXISTS "ecole_app_composante";

-- Tables École App - Configuration
DROP TABLE IF EXISTS "ecole_app_siteconfig";
DROP TABLE IF EXISTS "ecole_app_parametresite";

-- Tables Django System
DROP TABLE IF EXISTS "django_admin_log";
DROP TABLE IF EXISTS "django_session";
DROP TABLE IF EXISTS "django_migrations";
DROP TABLE IF EXISTS "django_content_type";

-- Tables Django Auth
DROP TABLE IF EXISTS "auth_user_user_permissions";
DROP TABLE IF EXISTS "auth_user_groups";
DROP TABLE IF EXISTS "auth_group_permissions";
DROP TABLE IF EXISTS "auth_permission";
DROP TABLE IF EXISTS "auth_user";
DROP TABLE IF EXISTS "auth_group";

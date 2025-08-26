-- =========================================================
-- RECRÉATION COMPLÈTE DU SCHÉMA D1 IDENTIQUE AU LOCAL
-- À copier-coller dans la console Cloudflare D1 APRÈS avoir vidé
-- =========================================================

-- Tables Django Auth (sans références pour commencer)
CREATE TABLE "auth_group" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(150) NOT NULL UNIQUE);

CREATE TABLE "django_content_type" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app_label" varchar(100) NOT NULL, "model" varchar(100) NOT NULL);

CREATE TABLE "auth_permission" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" varchar(100) NOT NULL, "name" varchar(255) NOT NULL);

CREATE TABLE "auth_group_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "password" varchar(128) NOT NULL, "last_login" datetime NULL, "is_superuser" bool NOT NULL, "username" varchar(150) NOT NULL UNIQUE, "last_name" varchar(150) NOT NULL, "email" varchar(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL, "first_name" varchar(150) NOT NULL);

CREATE TABLE "auth_user_groups" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "auth_user_user_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Tables Django System
CREATE TABLE "django_migrations" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, "applied" datetime NOT NULL);

CREATE TABLE "django_session" ("session_key" varchar(40) NOT NULL PRIMARY KEY, "session_data" text NOT NULL, "expire_date" datetime NOT NULL);

CREATE TABLE "django_admin_log" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "object_id" text NULL, "object_repr" varchar(200) NOT NULL, "action_flag" smallint unsigned NOT NULL CHECK ("action_flag" >= 0), "change_message" text NOT NULL, "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "action_time" datetime NOT NULL);

-- Tables École App - Structure de base
CREATE TABLE "ecole_app_composante" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL UNIQUE, "description" text NOT NULL, "active" bool NOT NULL, "date_creation" datetime NOT NULL);

CREATE TABLE "ecole_app_anneescolaire" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "date_debut" date NOT NULL, "date_fin" date NOT NULL, "active" bool NOT NULL, "date_creation" datetime NOT NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_creneau" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "date_creation" datetime NOT NULL, "heure_debut" time NULL, "heure_fin" time NULL, "jour" varchar(10) NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED, "archive" bool NOT NULL);

CREATE TABLE "ecole_app_professeur" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "date_creation" datetime NOT NULL, "email" varchar(254) NULL, "indemnisation" decimal NOT NULL, "telephone" varchar(20) NULL, "user_id" integer NULL UNIQUE REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "mot_de_passe_en_clair" varchar(100) NULL);

CREATE TABLE "ecole_app_classe" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "capacite" integer NOT NULL, "date_creation" datetime NOT NULL, "creneau_id" bigint NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_eleve" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "prenom" varchar(100) NOT NULL, "date_naissance" date NULL, "telephone" varchar(20) NOT NULL, "adresse" text NOT NULL, "email" varchar(254) NOT NULL, "date_creation" datetime NOT NULL, "classe_id" bigint NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL UNIQUE REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "montant_total" decimal NOT NULL, "mot_de_passe_en_clair" varchar(100) NULL, "remarque" text NULL, "archive" bool NOT NULL, "motif_archive" text NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED, prenom_pere varchar(100) NULL, prenom_mere varchar(100) NULL, telephone_secondaire varchar(20) NULL);

-- Tables École App - Relations Many-to-Many
CREATE TABLE "ecole_app_professeur_composantes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NOT NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_eleve_classes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_eleve_creneaux" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "creneau_id" bigint NOT NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Tables École App - Pédagogie
CREATE TABLE "ecole_app_carnetpedagogique" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_creation" datetime NOT NULL, "eleve_id" bigint NOT NULL UNIQUE REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_memorisation" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "debut_page" integer unsigned NOT NULL CHECK ("debut_page" >= 0), "fin_page" integer unsigned NOT NULL CHECK ("fin_page" >= 0), "remarques" text NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED, "enseignant_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_ecouteavantmemo" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "debut_page" integer unsigned NOT NULL CHECK ("debut_page" >= 0), "fin_page" integer unsigned NOT NULL CHECK ("fin_page" >= 0), "remarques" text NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED, "enseignant_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_repetition" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "sourate" varchar(100) NOT NULL, "page" integer unsigned NOT NULL CHECK ("page" >= 0), "nombre_repetitions" integer unsigned NOT NULL CHECK ("nombre_repetitions" >= 0), "derniere_date" date NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_revision" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "semaine" integer unsigned NOT NULL CHECK ("semaine" >= 0), "date" date NOT NULL, "jour" varchar(10) NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED, "nombre_hizb" decimal NOT NULL, "remarques" text NULL);

CREATE TABLE "ecole_app_progressioncoran" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "sourate_actuelle" varchar(100) NULL,
    "page_actuelle" integer NOT NULL,
    "direction_memorisation" varchar(10) NOT NULL,
    "date_mise_a_jour" datetime NOT NULL,
    "eleve_id" integer NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED,
    page_debut_sourate INTEGER DEFAULT 1 NOT NULL
);

CREATE TABLE "ecole_app_objectifmensuel" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "mois" date NOT NULL, "sourate" varchar(100) NULL, "numero_exercice" integer unsigned NULL CHECK ("numero_exercice" >= 0), "statut" varchar(20) NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "commentaire" text NOT NULL, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "description_libre" text NULL, page_debut integer NULL, page_fin integer NULL);

-- Tables École App - Compétences
CREATE TABLE "ecole_app_competencelivre" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "lecon" integer NOT NULL, "description" text NOT NULL, "ordre" integer NOT NULL, "date_creation" datetime NOT NULL);

CREATE TABLE "ecole_app_evaluationcompetence" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "statut" varchar(20) NOT NULL, "date_evaluation" date NOT NULL, "commentaire" text NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "competence_id" bigint NOT NULL REFERENCES "ecole_app_competencelivre" ("id") DEFERRABLE INITIALLY DEFERRED, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Tables École App - Modules et Cours
CREATE TABLE "ecole_app_module" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "publie" bool NOT NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_module_classes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "module_id" bigint NOT NULL REFERENCES "ecole_app_module" ("id") DEFERRABLE INITIALLY DEFERRED, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_document" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "fichier" varchar(100) NOT NULL, "date_creation" datetime NOT NULL, "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "module_id" bigint NOT NULL REFERENCES "ecole_app_module" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_courspartage" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "fichier" varchar(100) NOT NULL, "date_debut" datetime NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "actif" bool NOT NULL, "eleve_id" bigint NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_courspartage_classes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "courspartage_id" bigint NOT NULL REFERENCES "ecole_app_courspartage" ("id") DEFERRABLE INITIALLY DEFERRED, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Tables École App - Quiz et Évaluations
CREATE TABLE "ecole_app_quiz" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "publie" bool NOT NULL, "temps_limite" integer unsigned NULL CHECK ("temps_limite" >= 0), "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "module_id" bigint NOT NULL REFERENCES "ecole_app_module" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_question" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "texte" text NOT NULL, "type" varchar(20) NOT NULL, "points" integer unsigned NOT NULL CHECK ("points" >= 0), "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "quiz_id" bigint NOT NULL REFERENCES "ecole_app_quiz" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_choix" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "texte" varchar(255) NOT NULL, "est_correct" bool NOT NULL, "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "question_id" bigint NOT NULL REFERENCES "ecole_app_question" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_tentativequiz" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_debut" datetime NOT NULL, "date_fin" datetime NULL, "score" decimal NULL, "terminee" bool NOT NULL, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "quiz_id" bigint NOT NULL REFERENCES "ecole_app_quiz" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_reponse" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "texte_reponse" text NULL, "est_correcte" bool NOT NULL, "question_id" bigint NOT NULL REFERENCES "ecole_app_question" ("id") DEFERRABLE INITIALLY DEFERRED, "tentative_id" bigint NOT NULL REFERENCES "ecole_app_tentativequiz" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_reponse_choix_selectionnes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "reponse_id" bigint NOT NULL REFERENCES "ecole_app_reponse" ("id") DEFERRABLE INITIALLY DEFERRED, "choix_id" bigint NOT NULL REFERENCES "ecole_app_choix" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_noteexamen" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "type_examen" varchar(20) NOT NULL, "sourate_concernee" varchar(100) NULL, "note" decimal NOT NULL, "note_max" decimal NOT NULL, "date_examen" date NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "quiz_id" bigint NULL REFERENCES "ecole_app_quiz" ("id") DEFERRABLE INITIALLY DEFERRED, "tentative_quiz_id" bigint NULL REFERENCES "ecole_app_tentativequiz" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Tables École App - Présences
CREATE TABLE "ecole_app_presenceeleve" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "present" bool NOT NULL, "justifie" bool NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "classe_id" bigint NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED, "creneau_id" bigint NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_presenceprofesseur" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "present" bool NOT NULL, "justifie" bool NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "creneau_id" bigint NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Tables École App - Finances
CREATE TABLE "ecole_app_paiement" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "montant" decimal NOT NULL, "date" date NOT NULL, "methode" varchar(20) NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_paiementhistorique" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "montant" decimal NOT NULL, "date" date NOT NULL, "methode" varchar(20) NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "paiement_id" bigint NOT NULL REFERENCES "ecole_app_paiement" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_charge" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "categorie" varchar(20) NOT NULL, "montant" decimal NOT NULL, "description" text NOT NULL, "date" date NOT NULL, "date_creation" datetime NOT NULL, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Tables École App - Configuration
CREATE TABLE "ecole_app_listeattente" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "prenom" varchar(100) NOT NULL, "date_naissance" date NULL, "telephone" varchar(20) NOT NULL, "email" varchar(254) NOT NULL, "remarque" text NOT NULL, "date_ajout" datetime NOT NULL, "ajoute_definitivement" bool NOT NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

CREATE TABLE "ecole_app_siteconfig" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value" varchar(255) NOT NULL, "key" varchar(50) NOT NULL UNIQUE);

CREATE TABLE ecole_app_parametresite (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    montant_defaut_eleve DECIMAL(10, 2) NOT NULL DEFAULT 200.00,
    date_modification DATETIME NOT NULL
);

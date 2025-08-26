-- Schéma exact extrait de db.sqlite3
-- ==================================================

-- Table: auth_group
CREATE TABLE "auth_group" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(150) NOT NULL UNIQUE);

-- Table: auth_group_permissions
CREATE TABLE "auth_group_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: auth_permission
CREATE TABLE "auth_permission" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" varchar(100) NOT NULL, "name" varchar(255) NOT NULL);

-- Table: auth_user
CREATE TABLE "auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "password" varchar(128) NOT NULL, "last_login" datetime NULL, "is_superuser" bool NOT NULL, "username" varchar(150) NOT NULL UNIQUE, "last_name" varchar(150) NOT NULL, "email" varchar(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL, "first_name" varchar(150) NOT NULL);

-- Table: auth_user_groups
CREATE TABLE "auth_user_groups" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: auth_user_user_permissions
CREATE TABLE "auth_user_user_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: django_admin_log
CREATE TABLE "django_admin_log" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "object_id" text NULL, "object_repr" varchar(200) NOT NULL, "action_flag" smallint unsigned NOT NULL CHECK ("action_flag" >= 0), "change_message" text NOT NULL, "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "action_time" datetime NOT NULL);

-- Table: django_content_type
CREATE TABLE "django_content_type" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app_label" varchar(100) NOT NULL, "model" varchar(100) NOT NULL);

-- Table: django_migrations
CREATE TABLE "django_migrations" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, "applied" datetime NOT NULL);

-- Table: django_session
CREATE TABLE "django_session" ("session_key" varchar(40) NOT NULL PRIMARY KEY, "session_data" text NOT NULL, "expire_date" datetime NOT NULL);

-- Table: ecole_app_anneescolaire
CREATE TABLE "ecole_app_anneescolaire" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "date_debut" date NOT NULL, "date_fin" date NOT NULL, "active" bool NOT NULL, "date_creation" datetime NOT NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_carnetpedagogique
CREATE TABLE "ecole_app_carnetpedagogique" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_creation" datetime NOT NULL, "eleve_id" bigint NOT NULL UNIQUE REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_charge
CREATE TABLE "ecole_app_charge" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "categorie" varchar(20) NOT NULL, "montant" decimal NOT NULL, "description" text NOT NULL, "date" date NOT NULL, "date_creation" datetime NOT NULL, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_choix
CREATE TABLE "ecole_app_choix" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "texte" varchar(255) NOT NULL, "est_correct" bool NOT NULL, "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "question_id" bigint NOT NULL REFERENCES "ecole_app_question" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_classe
CREATE TABLE "ecole_app_classe" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "capacite" integer NOT NULL, "date_creation" datetime NOT NULL, "creneau_id" bigint NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_competencelivre
CREATE TABLE "ecole_app_competencelivre" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "lecon" integer NOT NULL, "description" text NOT NULL, "ordre" integer NOT NULL, "date_creation" datetime NOT NULL);

-- Table: ecole_app_composante
CREATE TABLE "ecole_app_composante" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL UNIQUE, "description" text NOT NULL, "active" bool NOT NULL, "date_creation" datetime NOT NULL);

-- Table: ecole_app_courspartage
CREATE TABLE "ecole_app_courspartage" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "fichier" varchar(100) NOT NULL, "date_debut" datetime NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "actif" bool NOT NULL, "eleve_id" bigint NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_courspartage_classes
CREATE TABLE "ecole_app_courspartage_classes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "courspartage_id" bigint NOT NULL REFERENCES "ecole_app_courspartage" ("id") DEFERRABLE INITIALLY DEFERRED, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_creneau
CREATE TABLE "ecole_app_creneau" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "date_creation" datetime NOT NULL, "heure_debut" time NULL, "heure_fin" time NULL, "jour" varchar(10) NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED, "archive" bool NOT NULL);

-- Table: ecole_app_document
CREATE TABLE "ecole_app_document" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "fichier" varchar(100) NOT NULL, "date_creation" datetime NOT NULL, "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "module_id" bigint NOT NULL REFERENCES "ecole_app_module" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_ecouteavantmemo
CREATE TABLE "ecole_app_ecouteavantmemo" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "debut_page" integer unsigned NOT NULL CHECK ("debut_page" >= 0), "fin_page" integer unsigned NOT NULL CHECK ("fin_page" >= 0), "remarques" text NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED, "enseignant_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_eleve
CREATE TABLE "ecole_app_eleve" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "prenom" varchar(100) NOT NULL, "date_naissance" date NULL, "telephone" varchar(20) NOT NULL, "adresse" text NOT NULL, "email" varchar(254) NOT NULL, "date_creation" datetime NOT NULL, "classe_id" bigint NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL UNIQUE REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "montant_total" decimal NOT NULL, "mot_de_passe_en_clair" varchar(100) NULL, "remarque" text NULL, "archive" bool NOT NULL, "motif_archive" text NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED, prenom_pere varchar(100) NULL, prenom_mere varchar(100) NULL, telephone_secondaire varchar(20) NULL);

-- Table: ecole_app_eleve_classes
CREATE TABLE "ecole_app_eleve_classes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_eleve_creneaux
CREATE TABLE "ecole_app_eleve_creneaux" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "creneau_id" bigint NOT NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_evaluationcompetence
CREATE TABLE "ecole_app_evaluationcompetence" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "statut" varchar(20) NOT NULL, "date_evaluation" date NOT NULL, "commentaire" text NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "competence_id" bigint NOT NULL REFERENCES "ecole_app_competencelivre" ("id") DEFERRABLE INITIALLY DEFERRED, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_listeattente
CREATE TABLE "ecole_app_listeattente" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "prenom" varchar(100) NOT NULL, "date_naissance" date NULL, "telephone" varchar(20) NOT NULL, "email" varchar(254) NOT NULL, "remarque" text NOT NULL, "date_ajout" datetime NOT NULL, "ajoute_definitivement" bool NOT NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_memorisation
CREATE TABLE "ecole_app_memorisation" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "debut_page" integer unsigned NOT NULL CHECK ("debut_page" >= 0), "fin_page" integer unsigned NOT NULL CHECK ("fin_page" >= 0), "remarques" text NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED, "enseignant_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_module
CREATE TABLE "ecole_app_module" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "publie" bool NOT NULL, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_module_classes
CREATE TABLE "ecole_app_module_classes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "module_id" bigint NOT NULL REFERENCES "ecole_app_module" ("id") DEFERRABLE INITIALLY DEFERRED, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_noteexamen
CREATE TABLE "ecole_app_noteexamen" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "type_examen" varchar(20) NOT NULL, "sourate_concernee" varchar(100) NULL, "note" decimal NOT NULL, "note_max" decimal NOT NULL, "date_examen" date NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "classe_id" bigint NOT NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "quiz_id" bigint NULL REFERENCES "ecole_app_quiz" ("id") DEFERRABLE INITIALLY DEFERRED, "tentative_quiz_id" bigint NULL REFERENCES "ecole_app_tentativequiz" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_objectifmensuel
CREATE TABLE "ecole_app_objectifmensuel" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "mois" date NOT NULL, "sourate" varchar(100) NULL, "numero_exercice" integer unsigned NULL CHECK ("numero_exercice" >= 0), "statut" varchar(20) NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "commentaire" text NOT NULL, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "description_libre" text NULL, page_debut integer NULL, page_fin integer NULL);

-- Table: ecole_app_paiement
CREATE TABLE "ecole_app_paiement" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "montant" decimal NOT NULL, "date" date NOT NULL, "methode" varchar(20) NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "annee_scolaire_id" bigint NULL REFERENCES "ecole_app_anneescolaire" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_paiementhistorique
CREATE TABLE "ecole_app_paiementhistorique" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "montant" decimal NOT NULL, "date" date NOT NULL, "methode" varchar(20) NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "paiement_id" bigint NOT NULL REFERENCES "ecole_app_paiement" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_parametresite
CREATE TABLE ecole_app_parametresite (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    montant_defaut_eleve DECIMAL(10, 2) NOT NULL DEFAULT 200.00,
                    date_modification DATETIME NOT NULL
                );

-- Table: ecole_app_presenceeleve
CREATE TABLE "ecole_app_presenceeleve" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "present" bool NOT NULL, "justifie" bool NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "classe_id" bigint NULL REFERENCES "ecole_app_classe" ("id") DEFERRABLE INITIALLY DEFERRED, "creneau_id" bigint NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_presenceprofesseur
CREATE TABLE "ecole_app_presenceprofesseur" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date" date NOT NULL, "present" bool NOT NULL, "justifie" bool NOT NULL, "commentaire" text NOT NULL, "date_creation" datetime NOT NULL, "creneau_id" bigint NULL REFERENCES "ecole_app_creneau" ("id") DEFERRABLE INITIALLY DEFERRED, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_professeur
CREATE TABLE "ecole_app_professeur" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "nom" varchar(100) NOT NULL, "date_creation" datetime NOT NULL, "email" varchar(254) NULL, "indemnisation" decimal NOT NULL, "telephone" varchar(20) NULL, "user_id" integer NULL UNIQUE REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "mot_de_passe_en_clair" varchar(100) NULL);

-- Table: ecole_app_professeur_composantes
CREATE TABLE "ecole_app_professeur_composantes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "professeur_id" bigint NOT NULL REFERENCES "ecole_app_professeur" ("id") DEFERRABLE INITIALLY DEFERRED, "composante_id" bigint NOT NULL REFERENCES "ecole_app_composante" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_progressioncoran
CREATE TABLE "ecole_app_progressioncoran" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "sourate_actuelle" varchar(100) NULL,
    "page_actuelle" integer NOT NULL,
    "direction_memorisation" varchar(10) NOT NULL,
    "date_mise_a_jour" datetime NOT NULL,
    "eleve_id" integer NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED
, page_debut_sourate INTEGER DEFAULT 1 NOT NULL);

-- Table: ecole_app_question
CREATE TABLE "ecole_app_question" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "texte" text NOT NULL, "type" varchar(20) NOT NULL, "points" integer unsigned NOT NULL CHECK ("points" >= 0), "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "quiz_id" bigint NOT NULL REFERENCES "ecole_app_quiz" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_quiz
CREATE TABLE "ecole_app_quiz" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "titre" varchar(200) NOT NULL, "description" text NOT NULL, "date_creation" datetime NOT NULL, "date_modification" datetime NOT NULL, "publie" bool NOT NULL, "temps_limite" integer unsigned NULL CHECK ("temps_limite" >= 0), "ordre" integer unsigned NOT NULL CHECK ("ordre" >= 0), "module_id" bigint NOT NULL REFERENCES "ecole_app_module" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_repetition
CREATE TABLE "ecole_app_repetition" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "sourate" varchar(100) NOT NULL, "page" integer unsigned NOT NULL CHECK ("page" >= 0), "nombre_repetitions" integer unsigned NOT NULL CHECK ("nombre_repetitions" >= 0), "derniere_date" date NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_reponse
CREATE TABLE "ecole_app_reponse" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "texte_reponse" text NULL, "est_correcte" bool NOT NULL, "question_id" bigint NOT NULL REFERENCES "ecole_app_question" ("id") DEFERRABLE INITIALLY DEFERRED, "tentative_id" bigint NOT NULL REFERENCES "ecole_app_tentativequiz" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_reponse_choix_selectionnes
CREATE TABLE "ecole_app_reponse_choix_selectionnes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "reponse_id" bigint NOT NULL REFERENCES "ecole_app_reponse" ("id") DEFERRABLE INITIALLY DEFERRED, "choix_id" bigint NOT NULL REFERENCES "ecole_app_choix" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Table: ecole_app_revision
CREATE TABLE "ecole_app_revision" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "semaine" integer unsigned NOT NULL CHECK ("semaine" >= 0), "date" date NOT NULL, "jour" varchar(10) NOT NULL, "carnet_id" bigint NOT NULL REFERENCES "ecole_app_carnetpedagogique" ("id") DEFERRABLE INITIALLY DEFERRED, "nombre_hizb" decimal NOT NULL, "remarques" text NULL);

-- Table: ecole_app_siteconfig
CREATE TABLE "ecole_app_siteconfig" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value" varchar(255) NOT NULL, "key" varchar(50) NOT NULL UNIQUE);

-- Table: ecole_app_tentativequiz
CREATE TABLE "ecole_app_tentativequiz" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_debut" datetime NOT NULL, "date_fin" datetime NULL, "score" decimal NULL, "terminee" bool NOT NULL, "eleve_id" bigint NOT NULL REFERENCES "ecole_app_eleve" ("id") DEFERRABLE INITIALLY DEFERRED, "quiz_id" bigint NOT NULL REFERENCES "ecole_app_quiz" ("id") DEFERRABLE INITIALLY DEFERRED);

-- Index

CREATE INDEX "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" ("group_id");

CREATE UNIQUE INDEX "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" ("group_id", "permission_id");

CREATE INDEX "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" ("permission_id");

CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");

CREATE UNIQUE INDEX "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" ("content_type_id", "codename");

CREATE INDEX "auth_user_groups_group_id_97559544" ON "auth_user_groups" ("group_id");

CREATE INDEX "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" ("user_id");

CREATE UNIQUE INDEX "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" ("user_id", "group_id");

CREATE INDEX "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" ("permission_id");

CREATE INDEX "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" ("user_id");

CREATE UNIQUE INDEX "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" ("user_id", "permission_id");

CREATE INDEX "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" ("content_type_id");

CREATE INDEX "django_admin_log_user_id_c564eba6" ON "django_admin_log" ("user_id");

CREATE UNIQUE INDEX "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");

CREATE INDEX "django_session_expire_date_a5c62663" ON "django_session" ("expire_date");

CREATE INDEX "ecole_app_anneescolaire_composante_id_19c5fd8a" ON "ecole_app_anneescolaire" ("composante_id");

CREATE INDEX "ecole_app_carnetpedagogique_composante_id_f8e8c956" ON "ecole_app_carnetpedagogique" ("composante_id");

CREATE INDEX "ecole_app_charge_annee_scolaire_id_867fbeb5" ON "ecole_app_charge" ("annee_scolaire_id");

CREATE INDEX "ecole_app_charge_composante_id_335a4e54" ON "ecole_app_charge" ("composante_id");

CREATE INDEX "ecole_app_charge_professeur_id_6541dc8a" ON "ecole_app_charge" ("professeur_id");

CREATE INDEX "ecole_app_choix_question_id_8aca241a" ON "ecole_app_choix" ("question_id");

CREATE INDEX "ecole_app_classe_annee_scolaire_id_635540cd" ON "ecole_app_classe" ("annee_scolaire_id");

CREATE INDEX "ecole_app_classe_composante_id_95dcd07d" ON "ecole_app_classe" ("composante_id");

CREATE INDEX "ecole_app_classe_creneau_id_21c0f114" ON "ecole_app_classe" ("creneau_id");

CREATE INDEX "ecole_app_classe_professeur_id_a0ff6a93" ON "ecole_app_classe" ("professeur_id");

CREATE INDEX "ecole_app_courspartage_classes_classe_id_7df36caa" ON "ecole_app_courspartage_classes" ("classe_id");

CREATE INDEX "ecole_app_courspartage_classes_courspartage_id_41ed685f" ON "ecole_app_courspartage_classes" ("courspartage_id");

CREATE UNIQUE INDEX "ecole_app_courspartage_classes_courspartage_id_classe_id_f361e76a_uniq" ON "ecole_app_courspartage_classes" ("courspartage_id", "classe_id");

CREATE INDEX "ecole_app_courspartage_eleve_id_2ef20197" ON "ecole_app_courspartage" ("eleve_id");

CREATE INDEX "ecole_app_courspartage_professeur_id_7bbb366c" ON "ecole_app_courspartage" ("professeur_id");

CREATE INDEX "ecole_app_creneau_composante_id_944ecf50" ON "ecole_app_creneau" ("composante_id");

CREATE INDEX "ecole_app_document_module_id_4ed08c14" ON "ecole_app_document" ("module_id");

CREATE INDEX "ecole_app_ecouteavantmemo_carnet_id_d5b7ade0" ON "ecole_app_ecouteavantmemo" ("carnet_id");

CREATE INDEX "ecole_app_ecouteavantmemo_enseignant_id_4c2cc2c9" ON "ecole_app_ecouteavantmemo" ("enseignant_id");

CREATE INDEX "ecole_app_eleve_annee_scolaire_id_1128ba22" ON "ecole_app_eleve" ("annee_scolaire_id");

CREATE INDEX "ecole_app_eleve_classe_id_9b43a839" ON "ecole_app_eleve" ("classe_id");

CREATE INDEX "ecole_app_eleve_classes_classe_id_8e7eaf4a" ON "ecole_app_eleve_classes" ("classe_id");

CREATE UNIQUE INDEX "ecole_app_eleve_classes_eleve_id_classe_id_791806cb_uniq" ON "ecole_app_eleve_classes" ("eleve_id", "classe_id");

CREATE INDEX "ecole_app_eleve_classes_eleve_id_eb2faa4b" ON "ecole_app_eleve_classes" ("eleve_id");

CREATE INDEX "ecole_app_eleve_composante_id_73219639" ON "ecole_app_eleve" ("composante_id");

CREATE INDEX "ecole_app_eleve_creneaux_creneau_id_bfe46157" ON "ecole_app_eleve_creneaux" ("creneau_id");

CREATE INDEX "ecole_app_eleve_creneaux_eleve_id_54ebef61" ON "ecole_app_eleve_creneaux" ("eleve_id");

CREATE UNIQUE INDEX "ecole_app_eleve_creneaux_eleve_id_creneau_id_d733dd36_uniq" ON "ecole_app_eleve_creneaux" ("eleve_id", "creneau_id");

CREATE INDEX "ecole_app_evaluationcompetence_competence_id_2c5af38c" ON "ecole_app_evaluationcompetence" ("competence_id");

CREATE INDEX "ecole_app_evaluationcompetence_eleve_id_cb4f71b4" ON "ecole_app_evaluationcompetence" ("eleve_id");

CREATE UNIQUE INDEX "ecole_app_evaluationcompetence_eleve_id_competence_id_a72af3ff_uniq" ON "ecole_app_evaluationcompetence" ("eleve_id", "competence_id");

CREATE INDEX "ecole_app_listeattente_composante_id_49d630b3" ON "ecole_app_listeattente" ("composante_id");

CREATE INDEX "ecole_app_memorisation_carnet_id_792cda33" ON "ecole_app_memorisation" ("carnet_id");

CREATE INDEX "ecole_app_memorisation_enseignant_id_f66c6c43" ON "ecole_app_memorisation" ("enseignant_id");

CREATE INDEX "ecole_app_module_classes_classe_id_a4c09e2a" ON "ecole_app_module_classes" ("classe_id");

CREATE INDEX "ecole_app_module_classes_module_id_6ef37c9e" ON "ecole_app_module_classes" ("module_id");

CREATE UNIQUE INDEX "ecole_app_module_classes_module_id_classe_id_887d2bb6_uniq" ON "ecole_app_module_classes" ("module_id", "classe_id");

CREATE INDEX "ecole_app_module_composante_id_d7db6491" ON "ecole_app_module" ("composante_id");

CREATE INDEX "ecole_app_module_professeur_id_0b606a47" ON "ecole_app_module" ("professeur_id");

CREATE INDEX "ecole_app_noteexamen_classe_id_a7eea595" ON "ecole_app_noteexamen" ("classe_id");

CREATE INDEX "ecole_app_noteexamen_eleve_id_b5477381" ON "ecole_app_noteexamen" ("eleve_id");

CREATE INDEX "ecole_app_noteexamen_professeur_id_80dd6720" ON "ecole_app_noteexamen" ("professeur_id");

CREATE INDEX "ecole_app_noteexamen_quiz_id_f37ab0be" ON "ecole_app_noteexamen" ("quiz_id");

CREATE INDEX "ecole_app_noteexamen_tentative_quiz_id_f61a9fbe" ON "ecole_app_noteexamen" ("tentative_quiz_id");

CREATE INDEX "ecole_app_objectifmensuel_eleve_id_58bd8dd3" ON "ecole_app_objectifmensuel" ("eleve_id");

CREATE INDEX "ecole_app_paiement_annee_scolaire_id_4fef75fb" ON "ecole_app_paiement" ("annee_scolaire_id");

CREATE INDEX "ecole_app_paiement_composante_id_9fbd9497" ON "ecole_app_paiement" ("composante_id");

CREATE INDEX "ecole_app_paiement_eleve_id_a1b0c3e8" ON "ecole_app_paiement" ("eleve_id");

CREATE INDEX "ecole_app_paiementhistorique_paiement_id_4e4e15d0" ON "ecole_app_paiementhistorique" ("paiement_id");

CREATE INDEX "ecole_app_presenceeleve_classe_id_4ba0d034" ON "ecole_app_presenceeleve" ("classe_id");

CREATE INDEX "ecole_app_presenceeleve_composante_id_574b29fe" ON "ecole_app_presenceeleve" ("composante_id");

CREATE INDEX "ecole_app_presenceeleve_creneau_id_8ad6df2c" ON "ecole_app_presenceeleve" ("creneau_id");

CREATE UNIQUE INDEX "ecole_app_presenceeleve_eleve_id_date_classe_id_7e89e4c2_uniq" ON "ecole_app_presenceeleve" ("eleve_id", "date", "classe_id");

CREATE INDEX "ecole_app_presenceeleve_eleve_id_fedaf4bd" ON "ecole_app_presenceeleve" ("eleve_id");

CREATE INDEX "ecole_app_presenceprofesseur_composante_id_b4495e83" ON "ecole_app_presenceprofesseur" ("composante_id");

CREATE INDEX "ecole_app_presenceprofesseur_creneau_id_e70354e8" ON "ecole_app_presenceprofesseur" ("creneau_id");

CREATE INDEX "ecole_app_presenceprofesseur_professeur_id_c3d8ed31" ON "ecole_app_presenceprofesseur" ("professeur_id");

CREATE UNIQUE INDEX "ecole_app_presenceprofesseur_professeur_id_date_creneau_id_c731d498_uniq" ON "ecole_app_presenceprofesseur" ("professeur_id", "date", "creneau_id");

CREATE INDEX "ecole_app_professeur_composantes_composante_id_b460739a" ON "ecole_app_professeur_composantes" ("composante_id");

CREATE INDEX "ecole_app_professeur_composantes_professeur_id_a2d9e170" ON "ecole_app_professeur_composantes" ("professeur_id");

CREATE UNIQUE INDEX "ecole_app_professeur_composantes_professeur_id_composante_id_e4f3c2c9_uniq" ON "ecole_app_professeur_composantes" ("professeur_id", "composante_id");

CREATE INDEX "ecole_app_progressioncoran_eleve_id_idx" ON "ecole_app_progressioncoran" ("eleve_id");

CREATE INDEX "ecole_app_question_quiz_id_c722dbad" ON "ecole_app_question" ("quiz_id");

CREATE INDEX "ecole_app_quiz_module_id_ba7c05f1" ON "ecole_app_quiz" ("module_id");

CREATE INDEX "ecole_app_repetition_carnet_id_4010be82" ON "ecole_app_repetition" ("carnet_id");

CREATE INDEX "ecole_app_reponse_choix_selectionnes_choix_id_50872b0e" ON "ecole_app_reponse_choix_selectionnes" ("choix_id");

CREATE UNIQUE INDEX "ecole_app_reponse_choix_selectionnes_reponse_id_choix_id_1135babc_uniq" ON "ecole_app_reponse_choix_selectionnes" ("reponse_id", "choix_id");

CREATE INDEX "ecole_app_reponse_choix_selectionnes_reponse_id_e56f9f34" ON "ecole_app_reponse_choix_selectionnes" ("reponse_id");

CREATE INDEX "ecole_app_reponse_question_id_8482f34f" ON "ecole_app_reponse" ("question_id");

CREATE INDEX "ecole_app_reponse_tentative_id_78d5830f" ON "ecole_app_reponse" ("tentative_id");

CREATE INDEX "ecole_app_revision_carnet_id_ffb99678" ON "ecole_app_revision" ("carnet_id");

CREATE INDEX "ecole_app_tentativequiz_eleve_id_bae331e2" ON "ecole_app_tentativequiz" ("eleve_id");

CREATE INDEX "ecole_app_tentativequiz_quiz_id_1198d190" ON "ecole_app_tentativequiz" ("quiz_id");

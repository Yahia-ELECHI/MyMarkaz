# Guide pour Console D1 Cloudflare

## 🚨 Problème : Console D1 ne gère pas les retours à la ligne

**Solution** : Copier-coller **une commande à la fois**

## 📋 Étape 1 : Vider les tables (une par une)

Copiez-collez ces commandes **UNE PAR UNE** dans la console D1 :

```sql
DROP TABLE IF EXISTS "ecole_app_reponse_choix_selectionnes";
```

```sql
DROP TABLE IF EXISTS "ecole_app_reponse";
```

```sql
DROP TABLE IF EXISTS "ecole_app_tentativequiz";
```

```sql
DROP TABLE IF EXISTS "ecole_app_noteexamen";
```

```sql
DROP TABLE IF EXISTS "ecole_app_question";
```

```sql
DROP TABLE IF EXISTS "ecole_app_choix";
```

```sql
DROP TABLE IF EXISTS "ecole_app_quiz";
```

```sql
DROP TABLE IF EXISTS "ecole_app_document";
```

```sql
DROP TABLE IF EXISTS "ecole_app_module_classes";
```

```sql
DROP TABLE IF EXISTS "ecole_app_module";
```

```sql
DROP TABLE IF EXISTS "ecole_app_courspartage_classes";
```

```sql
DROP TABLE IF EXISTS "ecole_app_courspartage";
```

```sql
DROP TABLE IF EXISTS "ecole_app_eleve_creneaux";
```

```sql
DROP TABLE IF EXISTS "ecole_app_eleve_classes";
```

```sql
DROP TABLE IF EXISTS "ecole_app_professeur_composantes";
```

```sql
DROP TABLE IF EXISTS "ecole_app_revision";
```

```sql
DROP TABLE IF EXISTS "ecole_app_repetition";
```

```sql
DROP TABLE IF EXISTS "ecole_app_progressioncoran";
```

```sql
DROP TABLE IF EXISTS "ecole_app_presenceprofesseur";
```

```sql
DROP TABLE IF EXISTS "ecole_app_presenceeleve";
```

```sql
DROP TABLE IF EXISTS "ecole_app_paiementhistorique";
```

```sql
DROP TABLE IF EXISTS "ecole_app_paiement";
```

```sql
DROP TABLE IF EXISTS "ecole_app_objectifmensuel";
```

```sql
DROP TABLE IF EXISTS "ecole_app_memorisation";
```

```sql
DROP TABLE IF EXISTS "ecole_app_listeattente";
```

```sql
DROP TABLE IF EXISTS "ecole_app_evaluationcompetence";
```

```sql
DROP TABLE IF EXISTS "ecole_app_ecouteavantmemo";
```

```sql
DROP TABLE IF EXISTS "ecole_app_charge";
```

```sql
DROP TABLE IF EXISTS "ecole_app_carnetpedagogique";
```

```sql
DROP TABLE IF EXISTS "ecole_app_eleve";
```

```sql
DROP TABLE IF EXISTS "ecole_app_classe";
```

```sql
DROP TABLE IF EXISTS "ecole_app_professeur";
```

```sql
DROP TABLE IF EXISTS "ecole_app_creneau";
```

```sql
DROP TABLE IF EXISTS "ecole_app_anneescolaire";
```

```sql
DROP TABLE IF EXISTS "ecole_app_competencelivre";
```

```sql
DROP TABLE IF EXISTS "ecole_app_composante";
```

```sql
DROP TABLE IF EXISTS "ecole_app_siteconfig";
```

```sql
DROP TABLE IF EXISTS "ecole_app_parametresite";
```

```sql
DROP TABLE IF EXISTS "django_admin_log";
```

```sql
DROP TABLE IF EXISTS "django_session";
```

```sql
DROP TABLE IF EXISTS "django_migrations";
```

```sql
DROP TABLE IF EXISTS "django_content_type";
```

```sql
DROP TABLE IF EXISTS "auth_user_user_permissions";
```

```sql
DROP TABLE IF EXISTS "auth_user_groups";
```

```sql
DROP TABLE IF EXISTS "auth_group_permissions";
```

```sql
DROP TABLE IF EXISTS "auth_permission";
```

```sql
DROP TABLE IF EXISTS "auth_user";
```

```sql
DROP TABLE IF EXISTS "auth_group";
```

## ⏭️ Ensuite : Créer les tables

Je vais créer des fichiers avec les commandes CREATE séparées de la même manière.

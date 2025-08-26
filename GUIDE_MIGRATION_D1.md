# Guide de Migration vers Cloudflare D1

## 📋 Résumé des fichiers préparés

Votre application MyMarkaz est maintenant prête pour la migration vers Cloudflare D1. Voici les fichiers clés créés/modifiés :

### Fichiers de configuration
- ✅ `gestion_markaz/settings.py` - Configuration Django avec support D1
- ✅ `cloudflare_d1.py` - Backend Django personnalisé pour D1 (amélioré)
- ✅ `requirements.txt` - Dépendances mises à jour (httpx ajouté)
- ✅ `.env.example` - Template de configuration environnement

### Scripts de migration
- ✅ `import_schema_d1.py` - Import du schéma vers D1
- ✅ `migrate_data_to_d1.py` - Export des données SQLite
- ✅ `schema_export_d1.sql` - Schéma compatible D1 (déjà existant)

## 🚀 Étapes de migration

### 1. Configuration Cloudflare D1
1. **Dashboard Cloudflare** → Workers & Pages → D1
2. **Créer une base** : nom `mymarkaz-db`
3. **Récupérer les identifiants** :
   - Database ID
   - Account ID (sidebar droite)
   - API Token (My Profile → API Tokens)

### 2. Configuration locale
1. **Copier** `.env.example` vers `.env`
2. **Remplir** les variables D1 dans `.env`:
```
USE_CLOUDFLARE_D1=True
CLOUDFLARE_ACCOUNT_ID=votre-account-id
CLOUDFLARE_DATABASE_ID=votre-database-id
CLOUDFLARE_API_TOKEN=votre-api-token
```

### 3. Installation des dépendances
```bash
pip install -r requirements.txt
```

### 4. Import du schéma
```bash
python import_schema_d1.py
```

### 5. Migration des données
```bash
python migrate_data_to_d1.py
```
Cela génère `data_export_d1.sql` à importer manuellement dans D1.

### 6. Configuration Cloudflare Pages
Dans votre projet Cloudflare Pages :

**Variables d'environnement** :
```
USE_CLOUDFLARE_D1=true
CLOUDFLARE_ACCOUNT_ID=votre-account-id
CLOUDFLARE_DATABASE_ID=votre-database-id
CLOUDFLARE_API_TOKEN=votre-api-token
SECRET_KEY=votre-cle-secrete
DEBUG=false
```

**Liaison D1** :
- Settings → Functions → D1 Database Bindings
- Nom : `mymarkaz-db`
- Database : sélectionner votre base D1

## ⚠️ Points d'attention

### Backend D1 personnalisé
- Le fichier `cloudflare_d1.py` fournit un adapter Django → D1
- En développement local : utilise SQLite
- En production : utilise l'API D1 REST

### Limitations D1 actuelles
- Pas de migrations Django automatiques
- Requêtes complexes limitées  
- Besoin d'adapter certaines fonctionnalités Django

### Tests recommandés
1. **Test local** : `USE_CLOUDFLARE_D1=False`
2. **Test D1** : `USE_CLOUDFLARE_D1=True`
3. **Vérifier** : connexions, requêtes de base
4. **Déployer** : sur Cloudflare Pages

## 🔧 Dépannage

### Erreur de connexion D1
- Vérifier les identifiants dans `.env`
- Tester avec `python import_schema_d1.py`

### Erreur de schéma
- Vérifier `schema_export_d1.sql`
- S'assurer que les tables sont créées

### Performance
- D1 REST API peut être plus lente que SQLite local
- Optimiser les requêtes pour réduire les appels API

## 📞 Support
- Documentation Cloudflare D1 : https://developers.cloudflare.com/d1/
- Django Database Backends : https://docs.djangoproject.com/en/5.0/ref/databases/

---
*Guide généré automatiquement pour le projet MyMarkaz*

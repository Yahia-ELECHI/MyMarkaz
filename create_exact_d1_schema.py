#!/usr/bin/env python
"""
Script pour créer un schéma D1 exactement identique à la base SQLite locale
"""
import os
import requests
from dotenv import load_dotenv

# Charger les variables d'environnement
load_dotenv()

CLOUDFLARE_API_TOKEN = os.getenv('CLOUDFLARE_API_TOKEN')
CLOUDFLARE_ACCOUNT_ID = os.getenv('CLOUDFLARE_ACCOUNT_ID') 
CLOUDFLARE_DATABASE_ID = os.getenv('CLOUDFLARE_DATABASE_ID')

def execute_d1_query(query, description=""):
    """Exécute une requête sur Cloudflare D1"""
    url = f"https://api.cloudflare.com/client/v4/accounts/{CLOUDFLARE_ACCOUNT_ID}/d1/database/{CLOUDFLARE_DATABASE_ID}/query"
    
    headers = {
        'Authorization': f'Bearer {CLOUDFLARE_API_TOKEN}',
        'Content-Type': 'application/json'
    }
    
    data = {
        'sql': query
    }
    
    try:
        if description:
            print(f"🔄 {description}")
        
        response = requests.post(url, json=data, headers=headers)
        
        if response.status_code == 200:
            result = response.json()
            if result.get('success'):
                print(f"✅ {description or 'Requête'} réussie")
                return True
            else:
                print(f"❌ Erreur API: {result.get('errors', [])}")
                return False
        else:
            print(f"❌ Erreur HTTP {response.status_code}: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Exception: {e}")
        return False

def get_existing_tables():
    """Récupère la liste des tables existantes"""
    url = f"https://api.cloudflare.com/client/v4/accounts/{CLOUDFLARE_ACCOUNT_ID}/d1/database/{CLOUDFLARE_DATABASE_ID}/query"
    
    headers = {
        'Authorization': f'Bearer {CLOUDFLARE_API_TOKEN}',
        'Content-Type': 'application/json'
    }
    
    data = {
        'sql': "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    }
    
    try:
        response = requests.post(url, json=data, headers=headers)
        if response.status_code == 200:
            result = response.json()
            if result.get('success') and result.get('result'):
                return [row[0] for row in result['result'][0]['results']]
        return []
    except:
        return []

def clean_d1_database():
    """Supprime toutes les tables existantes"""
    print("🧹 Nettoyage de la base D1...")
    
    tables = get_existing_tables()
    if not tables:
        print("ℹ️  Aucune table à supprimer")
        return True
    
    print(f"📋 Tables trouvées à supprimer: {len(tables)}")
    for table in tables:
        print(f"  - {table}")
    
    # Supprimer les tables dans l'ordre inverse pour éviter les contraintes
    for table in reversed(tables):
        if not execute_d1_query(f"DROP TABLE IF EXISTS `{table}`", f"Suppression {table}"):
            print(f"⚠️  Impossible de supprimer {table}")
    
    return True

def create_exact_schema():
    """Crée le schéma exact depuis le fichier local"""
    print("🏗️  Création du schéma identique...")
    
    if not os.path.exists('schema_local_exact.sql'):
        print("❌ Fichier schema_local_exact.sql introuvable")
        return False
    
    with open('schema_local_exact.sql', 'r', encoding='utf-8') as f:
        schema_content = f.read()
    
    # Séparer les CREATE TABLE et les CREATE INDEX
    lines = schema_content.split('\n')
    
    create_statements = []
    index_statements = []
    current_statement = ""
    in_index_section = False
    
    for line in lines:
        line = line.strip()
        
        if line == "-- Index":
            in_index_section = True
            continue
            
        if line.startswith('--') or not line:
            continue
            
        if in_index_section:
            if line.startswith('CREATE'):
                index_statements.append(line)
        else:
            if line.startswith('CREATE'):
                if current_statement:
                    create_statements.append(current_statement.strip())
                current_statement = line
            else:
                current_statement += " " + line
                
    # Ajouter la dernière instruction CREATE TABLE
    if current_statement and not in_index_section:
        create_statements.append(current_statement.strip())
    
    print(f"📊 {len(create_statements)} tables à créer")
    print(f"🗂️  {len(index_statements)} index à créer")
    
    # Créer les tables
    success_count = 0
    for i, statement in enumerate(create_statements, 1):
        table_name = statement.split()[2].replace('"', '').replace('`', '')
        if execute_d1_query(statement, f"Création table {table_name} ({i}/{len(create_statements)})"):
            success_count += 1
        else:
            print(f"❌ Échec création {table_name}")
    
    print(f"✅ {success_count}/{len(create_statements)} tables créées")
    
    # Créer les index
    index_success = 0
    for i, statement in enumerate(index_statements, 1):
        if execute_d1_query(statement, f"Création index ({i}/{len(index_statements)})"):
            index_success += 1
    
    print(f"✅ {index_success}/{len(index_statements)} index créés")
    
    return success_count == len(create_statements)

def main():
    """Fonction principale"""
    print("🎯 CRÉATION SCHÉMA D1 IDENTIQUE AU LOCAL")
    print("=" * 50)
    
    # Vérifier les variables d'environnement
    if not all([CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_DATABASE_ID]):
        print("❌ Variables d'environnement manquantes")
        print("Vérifiez CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_DATABASE_ID")
        return False
    
    # 1. Nettoyer la base
    if not clean_d1_database():
        print("❌ Échec du nettoyage")
        return False
    
    # 2. Créer le schéma exact
    if not create_exact_schema():
        print("❌ Échec de la création du schéma")
        return False
    
    print("\n🎉 SCHÉMA D1 CRÉÉ AVEC SUCCÈS !")
    print("   Le schéma D1 est maintenant identique au local")
    
    return True

if __name__ == "__main__":
    main()

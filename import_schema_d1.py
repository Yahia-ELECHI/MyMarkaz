#!/usr/bin/env python
"""
Script pour importer le schéma dans Cloudflare D1
"""
import os
import requests
from dotenv import load_dotenv

load_dotenv()

def import_schema_to_d1():
    """Importe le schéma SQL dans la base de données D1"""
    
    # Configuration D1
    account_id = os.getenv('CLOUDFLARE_ACCOUNT_ID')
    database_id = os.getenv('CLOUDFLARE_DATABASE_ID')
    api_token = os.getenv('CLOUDFLARE_API_TOKEN')
    
    if not all([account_id, database_id, api_token]):
        print("❌ Configuration D1 manquante. Vérifiez votre fichier .env")
        print("Variables requises: CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_DATABASE_ID, CLOUDFLARE_API_TOKEN")
        return False
    
    # Lecture du fichier de schéma
    schema_file = 'schema_export_d1.sql'
    if not os.path.exists(schema_file):
        print(f"❌ Fichier de schéma {schema_file} introuvable")
        return False
    
    with open(schema_file, 'r', encoding='utf-8') as f:
        schema_content = f.read()
    
    # URL de l'API D1
    url = f"https://api.cloudflare.com/client/v4/accounts/{account_id}/d1/database/{database_id}/query"
    
    headers = {
        'Authorization': f'Bearer {api_token}',
        'Content-Type': 'application/json'
    }
    
    # Diviser le schéma en requêtes individuelles
    statements = [stmt.strip() for stmt in schema_content.split(';') if stmt.strip()]
    
    print(f"🚀 Importation de {len(statements)} tables vers Cloudflare D1...")
    
    success_count = 0
    failed_statements = []
    
    for i, statement in enumerate(statements):
        if not statement:
            continue
            
        print(f"📝 Exécution de la requête {i+1}/{len(statements)}...")
        
        data = {
            'sql': statement
        }
        
        try:
            response = requests.post(url, headers=headers, json=data, timeout=30)
            
            if response.status_code == 200:
                result = response.json()
                if result.get('success', True):
                    success_count += 1
                    print(f"   ✅ Succès")
                else:
                    print(f"   ❌ Erreur D1: {result.get('errors', [])}")
                    failed_statements.append((i+1, statement, result.get('errors', [])))
            else:
                print(f"   ❌ Erreur HTTP {response.status_code}: {response.text}")
                failed_statements.append((i+1, statement, f"HTTP {response.status_code}"))
                
        except Exception as e:
            print(f"   ❌ Exception: {str(e)}")
            failed_statements.append((i+1, statement, str(e)))
    
    print(f"\n📊 Résultats de l'importation:")
    print(f"   ✅ Requêtes réussies: {success_count}")
    print(f"   ❌ Requêtes échouées: {len(failed_statements)}")
    
    if failed_statements:
        print(f"\n❌ Détail des erreurs:")
        for req_num, statement, error in failed_statements:
            print(f"   Requête {req_num}: {error}")
            print(f"   SQL: {statement[:100]}...")
    
    return len(failed_statements) == 0

def test_d1_connection():
    """Test la connexion à D1"""
    account_id = os.getenv('CLOUDFLARE_ACCOUNT_ID')
    database_id = os.getenv('CLOUDFLARE_DATABASE_ID')
    api_token = os.getenv('CLOUDFLARE_API_TOKEN')
    
    url = f"https://api.cloudflare.com/client/v4/accounts/{account_id}/d1/database/{database_id}/query"
    
    headers = {
        'Authorization': f'Bearer {api_token}',
        'Content-Type': 'application/json'
    }
    
    # Test simple
    data = {
        'sql': 'SELECT name FROM sqlite_master WHERE type="table";'
    }
    
    try:
        response = requests.post(url, headers=headers, json=data, timeout=10)
        
        if response.status_code == 200:
            result = response.json()
            if result.get('success', True):
                tables = result.get('result', [])
                print(f"🔗 Connexion D1 réussie!")
                print(f"📋 Tables trouvées: {len(tables)}")
                for table in tables:
                    if isinstance(table, dict):
                        print(f"   - {table.get('name', 'Unknown')}")
                return True
            else:
                print(f"❌ Erreur D1: {result.get('errors', [])}")
                return False
        else:
            print(f"❌ Erreur HTTP {response.status_code}: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Erreur de connexion: {str(e)}")
        return False

if __name__ == "__main__":
    print("🚀 Script d'importation Cloudflare D1")
    print("=" * 50)
    
    # Test de connexion
    if test_d1_connection():
        print("\n" + "=" * 50)
        
        # Importation du schéma
        if import_schema_to_d1():
            print("\n🎉 Importation terminée avec succès!")
        else:
            print("\n⚠️ Importation terminée avec des erreurs.")
    else:
        print("\n❌ Impossible de se connecter à D1. Vérifiez votre configuration.")

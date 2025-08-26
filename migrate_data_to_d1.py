#!/usr/bin/env python
"""
Script pour migrer les données de SQLite vers Cloudflare D1
"""
import os
import sqlite3
import requests
import json
from dotenv import load_dotenv

load_dotenv()

class D1DataMigrator:
    def __init__(self):
        self.account_id = os.getenv('CLOUDFLARE_ACCOUNT_ID')
        self.database_id = os.getenv('CLOUDFLARE_DATABASE_ID')
        self.api_token = os.getenv('CLOUDFLARE_API_TOKEN')
        
        if not all([self.account_id, self.database_id, self.api_token]):
            raise Exception("Configuration D1 manquante dans le fichier .env")
        
        self.d1_url = f"https://api.cloudflare.com/client/v4/accounts/{self.account_id}/d1/database/{self.database_id}"
        self.headers = {
            'Authorization': f'Bearer {self.api_token}',
            'Content-Type': 'application/json'
        }
    
    def execute_d1_query(self, sql, params=None):
        """Exécute une requête sur D1"""
        data = {'sql': sql}
        if params:
            data['params'] = params
            
        response = requests.post(
            f"{self.d1_url}/query",
            headers=self.headers,
            json=data,
            timeout=30
        )
        
        if response.status_code != 200:
            raise Exception(f"Erreur D1: {response.text}")
            
        result = response.json()
        if not result.get('success', True):
            raise Exception(f"Erreur D1: {result.get('errors', [])}")
            
        return result.get('result', [])
    
    def get_sqlite_tables(self):
        """Récupère la liste des tables SQLite"""
        if not os.path.exists('db.sqlite3'):
            print("❌ Fichier db.sqlite3 introuvable")
            return []
        
        conn = sqlite3.connect('db.sqlite3')
        cursor = conn.cursor()
        
        try:
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'ecole_app_%'")
            tables = [row[0] for row in cursor.fetchall()]
            return tables
        except sqlite3.Error as e:
            print(f"❌ Erreur: {e}")
            return []
        finally:
            conn.close()
    
    def get_table_data(self, table_name):
        """Récupère les données d'une table"""
        conn = sqlite3.connect('db.sqlite3')
        conn.row_factory = sqlite3.Row
        cursor = conn.cursor()
        
        try:
            cursor.execute(f"SELECT * FROM {table_name}")
            rows = cursor.fetchall()
            return [dict(row) for row in rows]
        except sqlite3.Error as e:
            print(f"⚠️ Erreur lecture {table_name}: {e}")
            return []
        finally:
            conn.close()
    
    def export_data_to_sql(self):
        """Exporte les données SQLite vers un fichier SQL pour D1"""
        tables = self.get_sqlite_tables()
        
        if not tables:
            print("❌ Aucune table trouvée")
            return False
        
        with open('data_export_d1.sql', 'w', encoding='utf-8') as f:
            f.write("-- Export des données pour Cloudflare D1\n\n")
            
            total_records = 0
            
            for table in tables:
                print(f"📋 Export de {table}...")
                data = self.get_table_data(table)
                
                if not data:
                    print(f"   ⚠️ Table vide")
                    continue
                
                # Déterminer la table D1 correspondante
                d1_table = table.replace('ecole_app_', '').capitalize()
                
                f.write(f"-- Table: {d1_table} ({len(data)} enregistrements)\n")
                
                for record in data:
                    # Construire l'INSERT
                    columns = list(record.keys())
                    values = []
                    
                    for value in record.values():
                        if value is None:
                            values.append('NULL')
                        elif isinstance(value, str):
                            # Échapper les quotes
                            escaped_value = value.replace("'", "''")
                            values.append(f"'{escaped_value}'")
                        else:
                            values.append(str(value))
                    
                    insert_sql = f"INSERT INTO {d1_table} ({', '.join(columns)}) VALUES ({', '.join(values)});"
                    f.write(insert_sql + "\n")
                
                f.write("\n")
                total_records += len(data)
                print(f"   ✅ {len(data)} enregistrements exportés")
            
            print(f"\n📊 Export terminé: {total_records} enregistrements au total")
            print(f"📄 Fichier généré: data_export_d1.sql")
            
        return True

def main():
    print("🚀 Migration des données vers Cloudflare D1")
    print("=" * 50)
    
    try:
        migrator = D1DataMigrator()
        
        # Export des données
        if migrator.export_data_to_sql():
            print("\n✅ Export terminé avec succès!")
            print("\n📝 Prochaines étapes:")
            print("1. Vérifiez le fichier data_export_d1.sql")
            print("2. Importez manuellement les données via le dashboard Cloudflare D1")
            print("3. Ou utilisez l'API D1 pour importer par batch")
        else:
            print("\n❌ Échec de l'export")
            
    except Exception as e:
        print(f"\n❌ Erreur: {str(e)}")

if __name__ == "__main__":
    main()

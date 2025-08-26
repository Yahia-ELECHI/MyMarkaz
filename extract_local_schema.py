#!/usr/bin/env python
"""
Script pour extraire le schéma exact de la base SQLite locale
"""
import sqlite3
import os

def extract_local_schema():
    """Extrait le schéma complet de db.sqlite3"""
    
    if not os.path.exists('db.sqlite3'):
        print("❌ Fichier db.sqlite3 introuvable")
        return False
    
    print("🔍 Extraction du schéma SQLite local...")
    
    conn = sqlite3.connect('db.sqlite3')
    cursor = conn.cursor()
    
    try:
        # Obtenir toutes les tables
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
        tables = cursor.fetchall()
        
        print(f"📋 Tables trouvées: {len(tables)}")
        
        schema_sql = []
        schema_sql.append("-- Schéma exact extrait de db.sqlite3")
        schema_sql.append("-- " + "="*50)
        schema_sql.append("")
        
        for table_name, in tables:
            if table_name.startswith('sqlite_'):
                continue  # Ignorer les tables système SQLite
            
            print(f"  📝 Extraction: {table_name}")
            
            # Obtenir la définition CREATE TABLE
            cursor.execute("SELECT sql FROM sqlite_master WHERE type='table' AND name=?", (table_name,))
            create_sql = cursor.fetchone()
            
            if create_sql and create_sql[0]:
                schema_sql.append(f"-- Table: {table_name}")
                schema_sql.append(create_sql[0] + ";")
                schema_sql.append("")
        
        # Obtenir les index
        cursor.execute("SELECT sql FROM sqlite_master WHERE type='index' AND sql IS NOT NULL ORDER BY name")
        indexes = cursor.fetchall()
        
        if indexes:
            schema_sql.append("-- Index")
            schema_sql.append("")
            for index_sql, in indexes:
                schema_sql.append(index_sql + ";")
                schema_sql.append("")
        
        # Écrire le fichier
        with open('schema_local_exact.sql', 'w', encoding='utf-8') as f:
            f.write('\n'.join(schema_sql))
        
        print(f"✅ Schéma extrait: schema_local_exact.sql")
        print(f"📊 {len([t for t, in tables if not t.startswith('sqlite_')])} tables exportées")
        
        # Afficher la liste des tables
        print("\n📋 Liste des tables:")
        for table_name, in tables:
            if not table_name.startswith('sqlite_'):
                print(f"  - {table_name}")
        
        return True
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return False
    finally:
        conn.close()

if __name__ == "__main__":
    extract_local_schema()

#!/usr/bin/env python
"""
Script pour générer le schéma D1 depuis les modèles Django
"""
import os
import sys
import django
from django.conf import settings
from django.core.management import execute_from_command_line
from django.db import connection
from io import StringIO

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'gestion_markaz.settings')
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Forcer l'utilisation de SQLite pour la génération du schéma
os.environ['USE_CLOUDFLARE_D1'] = 'False'

django.setup()

def generate_d1_schema():
    """Génère le schéma D1 depuis les modèles Django"""
    
    print("🔧 Génération du schéma D1 depuis les modèles Django...")
    
    # Récupérer toutes les migrations
    from django.core.management.commands.sqlmigrate import Command as SqlMigrateCommand
    from django.core.management.commands.showmigrations import Command as ShowMigrationsCommand
    from django.db.migrations.loader import MigrationLoader
    
    # Obtenir la liste des migrations
    loader = MigrationLoader(connection)
    migrations = loader.applied_migrations
    
    print(f"📋 Migrations appliquées trouvées: {len(migrations)}")
    
    # Générer le SQL pour toutes les migrations ecole_app
    ecole_migrations = [m for m in migrations if m[0] == 'ecole_app']
    
    if not ecole_migrations:
        print("❌ Aucune migration ecole_app trouvée")
        return False
    
    print(f"📱 Migrations ecole_app: {len(ecole_migrations)}")
    
    all_sql = []
    all_sql.append("-- Schéma D1 généré depuis les modèles Django")
    all_sql.append("-- Date de génération: " + str(datetime.now()))
    all_sql.append("")
    
    # Générer le SQL pour chaque migration
    for app_name, migration_name in sorted(ecole_migrations):
        print(f"  📝 Migration: {app_name}.{migration_name}")
        
        try:
            # Capturer la sortie de sqlmigrate
            from django.core.management import call_command
            from io import StringIO
            
            output = StringIO()
            call_command('sqlmigrate', app_name, migration_name, stdout=output)
            sql = output.getvalue()
            
            if sql.strip():
                all_sql.append(f"-- Migration: {app_name}.{migration_name}")
                all_sql.append(sql)
                all_sql.append("")
                
        except Exception as e:
            print(f"    ⚠️ Erreur pour {migration_name}: {e}")
    
    # Adapter le SQL pour D1
    d1_sql = adapt_sql_for_d1('\n'.join(all_sql))
    
    # Écrire le fichier
    with open('schema_d1_generated.sql', 'w', encoding='utf-8') as f:
        f.write(d1_sql)
    
    print(f"✅ Schéma généré: schema_d1_generated.sql")
    return True

def adapt_sql_for_d1(sql):
    """Adapte le SQL Django pour Cloudflare D1"""
    
    print("🔧 Adaptation du SQL pour Cloudflare D1...")
    
    # Remplacements pour la compatibilité D1
    replacements = [
        # Types de données
        ('AUTOINCREMENT', ''),  # D1 utilise INTEGER PRIMARY KEY
        ('varchar(', 'TEXT -- varchar('),  # D1 utilise TEXT
        ('datetime', 'TEXT'),  # D1 stocke les dates comme TEXT
        ('date', 'TEXT'),
        ('decimal', 'REAL'),
        ('boolean', 'INTEGER'),
        ('text', 'TEXT'),
        
        # Contraintes
        ('DEFERRABLE INITIALLY DEFERRED', ''),  # D1 ne supporte pas
        ('CHECK (', '-- CHECK ('),  # D1 supporte limitément
        
        # Préfixes de tables Django
        ('"ecole_app_', '"'),
        ('ecole_app_', ''),
        
        # Index
        ('CREATE INDEX', '-- CREATE INDEX'),  # Les créer séparément si nécessaire
        
        # Transactions
        ('BEGIN;', '-- BEGIN;'),
        ('COMMIT;', '-- COMMIT;'),
    ]
    
    adapted_sql = sql
    for old, new in replacements:
        adapted_sql = adapted_sql.replace(old, new)
    
    # Nettoyer les lignes vides multiples
    lines = adapted_sql.split('\n')
    clean_lines = []
    prev_empty = False
    
    for line in lines:
        if line.strip() == '':
            if not prev_empty:
                clean_lines.append(line)
            prev_empty = True
        else:
            clean_lines.append(line)
            prev_empty = False
    
    return '\n'.join(clean_lines)

if __name__ == "__main__":
    from datetime import datetime
    try:
        if generate_d1_schema():
            print("\n🎉 Génération terminée avec succès!")
            print("📄 Fichier créé: schema_d1_generated.sql")
        else:
            print("\n❌ Échec de la génération")
    except Exception as e:
        print(f"\n❌ Erreur: {str(e)}")
        import traceback
        traceback.print_exc()

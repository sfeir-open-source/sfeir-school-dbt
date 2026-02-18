"""
SFEIR School DBT - Explorateur de Base de Données DuckDB
Permet d'explorer visuellement les tables et données d'une base DuckDB
"""

import sys
import duckdb
from pathlib import Path
from datetime import datetime

try:
    from tabulate import tabulate
    HAS_TABULATE = True
except ImportError:
    HAS_TABULATE = False
    print("⚠️  Package 'tabulate' non installé. Affichage basique.")


def format_table(data, headers):
    """Formate un tableau de données"""
    if HAS_TABULATE:
        return tabulate(data, headers=headers, tablefmt='psql', showindex=False)
    else:
        # Affichage basique sans tabulate
        result = " | ".join(str(h) for h in headers) + "\n"
        result += "-" * 60 + "\n"
        for row in data:
            result += " | ".join(str(r) for r in row) + "\n"
        return result


def explore_database(db_path):
    """Explore une base de données DuckDB"""
    print(f"\n🔍 Exploration de : {db_path}")
    print(f"📅 Date : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()
    
    try:
        with duckdb.connect(str(db_path), read_only=True) as conn:
            # Lister les schémas
            schemas = conn.execute("SELECT schema_name FROM information_schema.schemata").fetchall()
            print(f"📊 {len(schemas)} schéma(s) trouvé(s)")
            
            # Lister les tables
            tables = conn.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'main'").fetchall()
            
            if not tables:
                print("❌ Aucune table trouvée dans cette base de données")
                print("💡 Avez-vous lancé 'dbt seed' et 'dbt run' ?")
                return
            
            print(f"📋 {len(tables)} table(s) dans le schéma 'main':\n")
            
            for table_tuple in tables:
                table_name = table_tuple[0]
                print(f"\n{'='*70}")
                print(f"📋 Table: {table_name}")
                print('='*70)
                
                # Compter les lignes
                count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
                print(f"   📊 Nombre de lignes: {count:,}")
                
                # Afficher le schéma
                schema = conn.execute(f"DESCRIBE {table_name}").fetchall()
                print("\n   📝 Colonnes:")
                
                schema_data = []
                for col in schema:
                    col_name = col[0]
                    col_type = col[1]
                    col_null = "NULL" if col[2] == "YES" else "NOT NULL"
                    schema_data.append([col_name, col_type, col_null])
                
                if HAS_TABULATE:
                    print("   " + tabulate(schema_data, headers=['Nom', 'Type', 'Contrainte'], tablefmt='simple').replace('\n', '\n   '))
                else:
                    for col in schema_data:
                        print(f"      • {col[0]} ({col[1]}) {col[2]}")
                
                # Afficher un aperçu des données
                if count > 0:
                    print(f"\n   👀 Aperçu (5 premières lignes):\n")
                    try:
                        preview = conn.execute(f"SELECT * FROM {table_name} LIMIT 5").fetchdf()
                        
                        if HAS_TABULATE:
                            # Tronquer les colonnes trop longues pour l'affichage
                            preview_display = preview.copy()
                            for col in preview_display.columns:
                                if preview_display[col].dtype == 'object':
                                    preview_display[col] = preview_display[col].astype(str).str[:50]
                            
                            table_str = tabulate(preview_display, headers='keys', tablefmt='psql', showindex=False)
                            print("   " + table_str.replace('\n', '\n   '))
                        else:
                            print(preview.to_string())
                    except Exception as e:
                        print(f"   ⚠️  Erreur lors de la récupération des données : {e}")
                
                # Statistiques basiques pour les colonnes numériques
                try:
                    numeric_cols = []
                    for col in schema:
                        col_name = col[0]
                        col_type = col[1].upper()
                        if any(t in col_type for t in ['INT', 'FLOAT', 'DOUBLE', 'DECIMAL', 'NUMERIC']):
                            numeric_cols.append(col_name)
                    
                    if numeric_cols and count > 0:
                        print(f"\n   📈 Statistiques (colonnes numériques):\n")
                        for col in numeric_cols:
                            stats = conn.execute(f"""
                                SELECT 
                                    MIN({col}) as min,
                                    MAX({col}) as max,
                                    AVG({col}) as avg,
                                    COUNT(DISTINCT {col}) as distinct_count
                                FROM {table_name}
                            """).fetchone()
                            
                            print(f"      {col}:")
                            print(f"         Min: {stats[0]}")
                            print(f"         Max: {stats[1]}")
                            print(f"         Avg: {stats[2]:.2f}" if stats[2] else "         Avg: N/A")
                            print(f"         Valeurs distinctes: {stats[3]}")
                except Exception as e:
                    # Ignorer les erreurs de stats
                    pass
            
            print(f"\n{'='*70}\n")
            print("✅ Exploration terminée !")
            
    except duckdb.Error as e:
        print(f"❌ Erreur DuckDB : {e}")
        return False
    except Exception as e:
        print(f"❌ Erreur : {e}")
        return False
    
    return True


def find_databases(workspace_path):
    """Trouve toutes les bases DuckDB dans le workspace"""
    dbs = []
    for db_file in workspace_path.rglob("*.duckdb"):
        # Ignorer les fichiers WAL
        if not db_file.name.endswith('.wal'):
            dbs.append(db_file)
    return dbs


def main():
    """Point d'entrée principal"""
    print("╔═══════════════════════════════════════════════════╗")
    print("║     Explorateur de Base de Données DuckDB         ║")
    print("╚═══════════════════════════════════════════════════╝")
    print()
    
    # Déterminer le chemin de la base
    if len(sys.argv) > 1:
        # Base spécifiée en argument
        db_path = Path(sys.argv[1])
        if not db_path.exists():
            print(f"❌ Base de données non trouvée : {db_path}")
            return 1
    else:
        # Chercher dans le workspace
        script_dir = Path(__file__).parent
        install_dir = script_dir.parent
        workspace_path = install_dir / "workspace"
        
        if not workspace_path.exists():
            print(f"❌ Workspace non trouvé : {workspace_path}")
            return 1
        
        dbs = find_databases(workspace_path)
        
        if not dbs:
            print("❌ Aucune base de données trouvée dans le workspace")
            print()
            print("💡 Avez-vous lancé 'dbt seed' dans un des labs ?")
            print()
            print("Pour initialiser un lab :")
            print("   1. Ouvrez le terminal DBT (raccourci bureau)")
            print("   2. cd workspace\\labs\\lab-01-models")
            print("   3. dbt seed")
            print("   4. dbt run")
            return 1
        
        print("📚 Bases de données disponibles:\n")
        for i, db in enumerate(dbs, 1):
            relative_path = db.relative_to(workspace_path)
            size = db.stat().st_size / 1024  # Taille en KB
            print(f"   {i}. {relative_path} ({size:.1f} KB)")
        
        print()
        try:
            choice = input("Choisissez une base (numéro) ou 'q' pour quitter : ").strip()
            if choice.lower() == 'q':
                return 0
            
            choice_idx = int(choice) - 1
            if choice_idx < 0 or choice_idx >= len(dbs):
                print("❌ Choix invalide")
                return 1
            
            db_path = dbs[choice_idx]
        except (ValueError, KeyboardInterrupt):
            print("\n❌ Annulé")
            return 1
    
    # Explorer la base
    success = explore_database(db_path)
    return 0 if success else 1


if __name__ == "__main__":
    try:
        exit_code = main()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        print("\n❌ Interrompu par l'utilisateur")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Erreur inattendue : {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

@echo off
REM Nettoyer tout (DB + venv)
echo 🧹 Nettoyage complet...
if exist venv rmdir /s /q venv
if exist ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb del /q ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb
if exist ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb.wal del /q ..\..\shared\dbt-projects\starter\sfeir_dbt.duckdb.wal
if exist ..\..\shared\dbt-projects\starter\dbt_packages rmdir /s /q ..\..\shared\dbt-projects\starter\dbt_packages
if exist ..\..\shared\dbt-projects\starter\target rmdir /s /q ..\..\shared\dbt-projects\starter\target
if exist ..\..\shared\dbt-projects\starter\logs rmdir /s /q ..\..\shared\dbt-projects\starter\logs
echo ✅ Nettoyage terminé !

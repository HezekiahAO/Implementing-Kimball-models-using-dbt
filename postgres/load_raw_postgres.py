"""This helps me runs a SQL file against Postgres (no psql needed).
Default: postgres/01_create_raw.sql (creates and fills the raw.* tables).
Usage:   python postgres/load_raw_postgres.py [path/to/file.sql]
Connection comes from the same env vars dbt uses (see postgres/profiles.yml)."""
import os, pathlib, sys
import psycopg2

default = pathlib.Path(__file__).parent / "01_create_raw.sql"
sql_file = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else default

conn = psycopg2.connect(
    host=os.getenv("PGHOST", "localhost"),
    port=int(os.getenv("PGPORT", "5432")),
    user=os.getenv("PGUSER", "dbt_user"),
    password=os.getenv("PGPASSWORD", "dbt_pass"),
    dbname=os.getenv("PGDATABASE", "fintech"),
)
with conn, conn.cursor() as cur:
    cur.execute(sql_file.read_text())
print(f"ran {sql_file}")

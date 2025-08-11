import os
import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv

# Load environment variables from open-webui.env
load_dotenv("open-webui.env")

# Read the connection string
def setup_database_connection(env_var_name):
    connection_string = os.getenv(env_var_name)

    if not connection_string:
        raise ValueError(f"{env_var_name} is not set in the environment file")

    conn_params = psycopg2.extensions.parse_dsn(connection_string)
    host = conn_params.get("host")
    port = conn_params.get("port")
    user = conn_params.get("user")
    password = conn_params.get("password")
    database_name = conn_params.get("dbname")

    default_conn_string = f"host={host} port={port} user={user} password={password} dbname=postgres"

    conn = None
    try:
        conn = psycopg2.connect(default_conn_string)
        conn.autocommit = True
        with conn.cursor() as cursor:
            cursor.execute("SELECT 1 FROM pg_database WHERE datname = %s", (database_name,))
            if not cursor.fetchone():
                cursor.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(database_name)))
                print(f"Database '{database_name}' created successfully.")
            else:
                print(f"Database '{database_name}' already exists.")
    except psycopg2.Error as e:
        print(f"PostgreSQL Error: {e}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if conn:
            conn.close()

setup_database_connection("DATABASE_URL")
setup_database_connection("PGVECTOR_DB_URL")
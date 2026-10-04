import os
import mssql_python


def get_connection():
    return mssql_python.connect(os.environ["DATABASE_URL"])
import azure.functions as func
import datetime
import json
import logging
from db.connection import get_connection

app = func.FunctionApp()

@app.route(route="health", methods=["GET"], auth_level=func.AuthLevel.ANONYMOUS)
def health(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Health check!')
    body = {
        "status": "ok",
    }
    try:
        with get_connection() as conn:
            conn.cursor().execute("SELECT 1").fetchone()
        body["database"] = "ok"
    except Exception:
        logging.exception("DB check failed")
        body["database"] = "error"
    return func.HttpResponse(
        json.dumps(body),
        status_code=200,
        mimetype="application/json",
    )
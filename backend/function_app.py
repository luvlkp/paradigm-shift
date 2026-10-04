import azure.functions as func
import datetime
import json
import logging
from db.connection import get_connection
from routes.auth import bp as auth_bp
from routes.meetings import bp as meetings_bp
from routes.jargon import bp as jargon_bp
from routes.leaderboard import bp as leaderboard_bp

app = func.FunctionApp()

app.register_functions(auth_bp)
app.register_functions(meetings_bp)
app.register_functions(jargon_bp)
app.register_functions(leaderboard_bp)

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
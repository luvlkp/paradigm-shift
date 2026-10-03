import azure.functions as func
import datetime
import json
import logging

app = func.FunctionApp()

@app.route(route="health", methods=["GET"], auth_level=func.AuthLevel.ANONYMOUS)
def health(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Health check!')
    body = {
        "status": "ok",
    }
    return func.HttpResponse(
        json.dumps(body),
        status_code=200,
        mimetype="application/json",
    )
import json

import azure.functions as func

from db import queries


def json_response(data, status=200):
    return func.HttpResponse(
        json.dumps(data, default=str),
        status_code=status,
        mimetype="application/json",
    )


def error(message, status):
    return json_response({"error": message}, status)


def get_current_user(req):
    """Return the user for 'Authorization: Bearer <token>', or None."""
    header = req.headers.get("Authorization", "").strip()
    if not header.lower().startswith("bearer "):
        return None
    token = header[7:].strip()  # sliced from the original, so the token keeps its case
    if not token:
        return None
    return queries.get_users_by_token(token)
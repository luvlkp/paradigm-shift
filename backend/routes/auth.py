import secrets

import azure.functions as func

from db import queries
from http_utils import error, json_response

bp = func.Blueprint()

@bp.route(route="auth/join", methods=["POST"], auth_level=func.AuthLevel.ANONYMOUS)
def join(req: func.HttpRequest) -> func.HttpResponse:
    try:
        body = req.get_json
    except ValueError:
        return error("Request body must be JSON", 400)

    name = (body.get("display_name") or "").strip()
    code = (body.get("join_code") or "").strip()
    if not name or not code:
        return error("display_name and join_code are required", 400)

    company = queries.get_company_by_join_code(code)
    if not company:
        return error("Unknown company code", 404)

    token = secrets.token_urlsafe(32) # hash to refer to a user as
    user_id = queries.create_user(company["id"], name, token)
    return json_response(
        {"user_id": user_id, "token": token, "company_name": company["name"]},
        201,
    )
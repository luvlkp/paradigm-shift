import azure.functions as func

from db import queries
from http_utils import error, get_current_user, json_response

bp = func.Blueprint()

@bp.route("meetings/start", methods=["POST"], auth_level=func.AuthLevel.ANONYMOUS)
def start(req: func.HttpRequest) -> func.HttpResponse:
    user = get_current_user(req)
    if not user:
        return error("Token is missing or invalid", 401)
    try:
        session_id = queries.create_session(user["id"])
    except Exception:
        logging.exception("create_session failed")
        return error("Error creating session", 500)
    return json_response({"session_id": session_id}, 201)

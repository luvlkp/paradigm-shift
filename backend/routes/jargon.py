import azure.functions as func

from db import queries
from http_utils import error, get_current_user, json_response

bp = func.Blueprint()


@bp.route(route="jargon", methods=["GET"], auth_level=func.AuthLevel.ANONYMOUS)
def list_jargon(req: func.HttpRequest) -> func.HttpResponse:
    user = get_current_user(req)
    if not user:
        return error("Invalid or missing token", 401)

    return json_response({"jargon": queries.get_jargon_for_specific_user(user["id"])})
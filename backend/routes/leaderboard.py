import azure.functions as func

from db import queries
from http_utils import error, get_current_user, json_response

bp = func.Blueprint()


@bp.route(route="leaderboard", methods=["GET"], auth_level=func.AuthLevel.ANONYMOUS)
def leaderboard(req: func.HttpRequest) -> func.HttpResponse:
    user = get_current_user(req)
    if not user:
        return error("Invalid or missing token", 401)

    rows = queries.get_top_users(user["company_id"], limit=10)
    ranked = [
        {"rank": i + 1, "display_name": r["display_name"], "points": r["points"]}
        for i, r in enumerate(rows)
    ]
    return json_response({"leaderboard": ranked})
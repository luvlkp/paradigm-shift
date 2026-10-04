from fastapi import APIRouter, Request

from db import queries
from http_utils import error, get_current_user, json_response

router = APIRouter()


@router.get("/leaderboard")
def leaderboard(request: Request):
    user = get_current_user(request)
    if not user:
        return error("Invalid or missing token", 401)

    rows = queries.get_top_users(user["company_id"], limit=10)
    ranked = [
        {"rank": i + 1, "display_name": r["display_name"], "points": r["points"]}
        for i, r in enumerate(rows)
    ]
    return json_response({"leaderboard": ranked})

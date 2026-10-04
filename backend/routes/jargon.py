from fastapi import APIRouter, Request

from db import queries
from http_utils import error, get_current_user, json_response

router = APIRouter()


@router.get("/jargon")
def list_jargon(request: Request):
    user = get_current_user(request)
    if not user:
        return error("Invalid or missing token", 401)

    return json_response({"jargon": queries.get_jargon_for_specific_user(user["id"])})

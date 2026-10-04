import logging

from fastapi import APIRouter, Request

from db import queries
from http_utils import error, get_current_user, json_response

router = APIRouter()


@router.post("/meetings/start")
def start(request: Request):
    user = get_current_user(request)
    if not user:
        return error("Token is missing or invalid", 401)
    try:
        session_id = queries.create_session(user["id"])
    except Exception:
        logging.exception("create_session failed")
        return error("Error creating session", 500)
    return json_response({"session_id": session_id}, 201)

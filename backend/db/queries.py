import os
from db.connection import get_connection

# USE_MOCK = os.environ.get("USE_MOCK_DB") == "true"

# MOCK_JARGON = [
#     {"id": 1, "term": "circle back", "meaning": "Return to a topic later", "mastery": 40},
#     {"id": 2, "term": "synergy", "meaning": "Combined effort that beats the parts", "mastery": 10},
# ]


# def list_jargon(user_id: int):
#     if USE_MOCK:
#         return MOCK_JARGON
#     # real SQL goes here later
#     raise NotImplementedError

def _fetch(sql, parameters=(), one=False):
    conn = get_connection()
    try:
        curr = conn.cursor()
        curr.execute(sql, parameters)
        cols = [c[0] for c in curr.description]
        rows = [dict(zip(cols, r)) for r in curr.fetchall()]
        if one:
            return rows[0] if rows else None
        return rows
    finally:
        conn.close()

def get_company_by_join_code(join_code):
    return _fetch(
        "SELECT * FROM Companies WHERE join_code = ?",
        (join_code,),
        one=True,
    )

def get_users_by_token(token):
    return _fetch(
        "SELECT * FROM users WHERE token = ?",
        (token,),
        one=True,
    )

def get_jargon_for_specific_user(user_id):
    return _fetch(
        "SELECT j.id, j.term, j.meaning, j.example_sentence, uj.times_heard, uj.mastery "
        "FROM user_jargon uj JOIN jargon j ON j.id = uj.jargon_id "
        "WHERE uj.user_id = ? ORDER BY uj.mastery ASC, j.term ASC",
        (user_id,),
    )

def get_jargon_meaning(company_id, term):
    return _fetch(
        "SELECT meaning FROM jargon WHERE company_id = ? AND term_normalized = ?",
        (company_id, term.strip().lower()),
        one=True,
    )

def get_jargon_context(company_id, term):
    return _fetch(
        "SELECT example_sentence FROM jargon WHERE company_id = ? AND term = ?",
        (company_id, term.strip().lower()),
        one=True,
    )

def get_top_users(company_id, limit=10):
    return _fetch(
        f"SELECT TOP {int(limit)} display_name, points FROM users WHERE company_id = (?) ORDER BY points DESC, display_name ASC",
        (company_id,),
    )

def _insert_and_return_id(sql, params=()):
    conn = get_connection()
    try:
        curr = conn.cursor()
        curr.execute(sql, params)
        new_id = curr.fetchone()[0]
        conn.commit()
        return new_id
    finally:
        conn.close()

def create_user(company_id, display_name, token):
    return _insert_and_return_id(
        "INSERT INTO users (company_id, display_name, token) OUTPUT INSERTED.id VALUES(?, ?, ?)",
        (company_id, display_name, token),
    )

def create_session(user_id):
    return _insert_and_return_id(
        "INSERT INTO meeting_sessions (user_id) OUTPUT INSERTED.id VALUES (?)",
        (user_id,),
    )

def create_company(name, join_code):
    return _insert_and_return_id(
        "INSERT INTO companies (name, join_codde) OUTPUT INSERTED.id VALUES (?, ?)",
        (name, join_code),
    )

def insert_list_of_jargon(jargon_list, company_id):
    # jargon_list: list of {"term", "meaning", "example"} dicts (example may be None)
    debug_log = []
    for jargon in jargon_list:
        term = jargon["term"].strip()
        debug_log.append(_insert_and_return_id(
            """MERGE INTO jargon AS target 
            USING (VALUES (?, ?, ?, ?, ?)) AS source (company_id, term, term_normalized, meaning, example_sentence)
            ON (target.company_id = source.company_id AND target.term_normalized = source.term_normalized)
            WHEN MATCHED THEN
                UPDATE SET target.meaning = source.meaning,
                           target.example_sentence = COALESCE(source.example_sentence, target.example_sentence)
            WHEN NOT MATCHED THEN
                INSERT (company_id, term, term_normalized, meaning, example_sentence)
                VALUES (source.company_id, source.term, source.term_normalized, source.meaning, source.example_sentence)
            OUTPUT INSERTED.id""",
            (company_id, term, term.lower(), jargon["meaning"], jargon.get("example")),
        ))
    return debug_log

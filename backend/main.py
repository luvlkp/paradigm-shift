import asyncio
import os
import json
import tempfile
import threading
import time
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import azure.cognitiveservices.speech as speechsdk
from google import genai
from google.genai.errors import APIError

load_dotenv()

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:65167", "http://127.0.0.1:65167"],
    allow_origin_regex=r"^http://(localhost|127\.0\.0\.1):\d+$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

SPEECH_KEY = os.environ["AZURE_SPEECH_KEY"]
SPEECH_REGION = os.environ["AZURE_SPEECH_REGION"]


@app.get("/health")
async def health():
    return {"status": "ok"}


def transcribe(audio_path: str) -> str:
    speech_config = speechsdk.SpeechConfig(
        subscription=SPEECH_KEY, region=SPEECH_REGION
    )
    audio_config = speechsdk.AudioConfig(filename=audio_path)
    recognizer = speechsdk.SpeechRecognizer(
        speech_config=speech_config, audio_config=audio_config
    )

    parts = []
    done = threading.Event()

    def recognized(evt):
        if evt.result.reason == speechsdk.ResultReason.RecognizedSpeech:
            parts.append(evt.result.text)

    def stop(evt):
        done.set()

    recognizer.recognized.connect(recognized)
    recognizer.session_stopped.connect(stop)
    recognizer.canceled.connect(stop)

    recognizer.start_continuous_recognition()
    done.wait()
    recognizer.stop_continuous_recognition()
    return " ".join(parts)


def extract_jargon_and_quiz(transcript: str) -> dict:
    client = genai.Client(api_key=os.environ["GEMINI_API_KEY"])

    system_prompt = (
        "You help professionals learn workplace jargon. Given a meeting "
        "transcript, extract the corporate/business jargon terms used, "
        "and create quiz questions to test understanding of them."
    )

    user_prompt = f"""Transcript:
{transcript}

Return a JSON object with two keys:
- "jargon": a list of objects, each with "term", "definition", "example"
- "quiz": a list of objects, each with "question", "options" (list of 4 strings), "correctIndex" (0-3), "term"
"""

    for attempt in range(4):
        try:
            response = client.models.generate_content(
                model=os.environ.get("GEMINI_MODEL", "gemini-3.8-flash"),
                contents=f"{system_prompt}\n\n{user_prompt}",
                config={"response_mime_type": "application/json"},
            )
            break
        except APIError as e:
            is_temporary = e.code == 503 or e.status == "UNAVAILABLE"
            if not is_temporary or attempt == 3:
                raise
            time.sleep(2 ** (attempt + 1))

    return json.loads(response.text)


@app.post("/analyze")
async def analyze(file: UploadFile = File(...)):
    suffix = os.path.splitext(file.filename)[1] or ".wav"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
        tmp.write(await file.read())
        audio_path = tmp.name

    try:
        transcript = await asyncio.to_thread(transcribe, audio_path)
    except Exception:
        raise HTTPException(
            status_code=422,
            detail="That file couldn't be read as audio. Please upload a valid audio file like mp3, wav, or m4a.",
        )
    finally:
        os.unlink(audio_path)

    if not transcript.strip():
        raise HTTPException(status_code=422, detail="No speech detected")

    result = extract_jargon_and_quiz(transcript)
    return {
        "transcript": transcript,
        "jargon": result.get("jargon", []),
        "quiz": result.get("quiz", []),
    }

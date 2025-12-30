from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/test")
async def test_payments():
    return JSONResponse(content={"message": "This is a test endpoint for payments"})

# Example for voice route placeholder
@router.get("/fake_audio")
async def fake_audio():
    if "payments" == "voice":
        return JSONResponse(content={"audio_url": "/static/audio/fake_audio.mp3"})
    return JSONResponse(content={"audio_url": None})

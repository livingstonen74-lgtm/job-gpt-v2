from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/test")
async def test_proposals():
    return JSONResponse(content={"message": "This is a test endpoint for proposals"})

# Example for voice route placeholder
@router.get("/fake_audio")
async def fake_audio():
    if "proposals" == "voice":
        return JSONResponse(content={"audio_url": "/static/audio/fake_audio.mp3"})
    return JSONResponse(content={"audio_url": None})

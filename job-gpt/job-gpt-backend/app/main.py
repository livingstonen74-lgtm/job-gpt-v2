from fastapi import FastAPI
from app.routes import cv, voice, education, proposals, payments

app = FastAPI()
app.include_router(cv.router, prefix="/api/cv")
app.include_router(voice.router, prefix="/api/voice")
app.include_router(education.router, prefix="/api/education")
app.include_router(proposals.router, prefix="/api/proposals")
app.include_router(payments.router, prefix="/api/payments")

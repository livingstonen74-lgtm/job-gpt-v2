#!/bin/bash
set -e

# ===================================================
# Job-GPT Repo Generator Script
# Generates full backend + frontend + GitHub Actions skeleton
# ===================================================

BASE_DIR=$(pwd)
echo "Creating Job-GPT repo in $BASE_DIR/job-gpt"

mkdir -p job-gpt
cd job-gpt

# ------------------------
# .gitignore
# ------------------------
cat <<EOL > .gitignore
# Python
*.pyc
__pycache__/
venv/
.env
*.sqlite3

# JS
node_modules/

# Logs
gunicorn_logs/

# OS
.DS_Store
EOL

# ------------------------
# README.md
# ------------------------
cat <<EOL > README.md
# Job-GPT
AI Career & CV Intelligence Platform for South Sudan
EOL

# ------------------------
# deploy_jobgpt.sh (skeleton)
# ------------------------
cat <<'EOL' > deploy_jobgpt.sh
#!/bin/bash
set -e
echo "Deployment script placeholder"
EOL

chmod +x deploy_jobgpt.sh

# ------------------------
# Backend folders
# ------------------------
mkdir -p job-gpt-backend/app/routes
mkdir -p job-gpt-backend/app/models
mkdir -p job-gpt-backend/app/services
mkdir -p job-gpt-backend/app/prompts
mkdir -p job-gpt-backend/scripts
mkdir -p job-gpt-backend/data

# ------------------------
# Backend main.py
# ------------------------
cat <<EOL > job-gpt-backend/app/main.py
from fastapi import FastAPI
from app.routes import cv, voice, education, proposals, payments

app = FastAPI()
app.include_router(cv.router, prefix="/api/cv")
app.include_router(voice.router, prefix="/api/voice")
app.include_router(education.router, prefix="/api/education")
app.include_router(proposals.router, prefix="/api/proposals")
app.include_router(payments.router, prefix="/api/payments")
EOL

# ------------------------
# Backend routes placeholders
# ------------------------
for r in cv voice education proposals payments; do
cat <<EOL > job-gpt-backend/app/routes/$r.py
from fastapi import APIRouter
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/test")
async def test_$r():
    return JSONResponse(content={"message": "This is a test endpoint for $r"})

# Example for voice route placeholder
@router.get("/fake_audio")
async def fake_audio():
    if "$r" == "voice":
        return JSONResponse(content={"audio_url": "/static/audio/fake_audio.mp3"})
    return JSONResponse(content={"audio_url": None})
EOL
done

# ------------------------
# Backend .env.test
# ------------------------
cat <<EOL > job-gpt-backend/.env.test
OPENAI_API_KEY=fake
ELEVENLABS_API_KEY=fake
ELEVENLABS_VOICE_ID=fake
DATABASE_URL=sqlite:///db_test.sqlite3
MOMO_API_USER=fake
MOMO_API_KEY=fake
MOMO_ENVIRONMENT=sandbox
EOL

# ------------------------
# Backend fake jobs data
# ------------------------
cat <<EOL > job-gpt-backend/data/jobs.json
[
  {
    "title": "Program Officer - Fake NGO",
    "organization": "Fake Relief",
    "description": "Fake job description for testing"
  },
  {
    "title": "Intern - UNDP",
    "organization": "UNDP South Sudan",
    "description": "Fake internship description"
  },
  {
    "title": "Consultancy - Tender Writing",
    "organization": "NGO Forum SS",
    "description": "Fake tender/proposal writing placeholder"
  }
]
EOL

# ------------------------
# Backend requirements.txt
# ------------------------
cat <<EOL > job-gpt-backend/requirements.txt
fastapi
uvicorn
gunicorn
python-dotenv
EOL

# ------------------------
# Frontend folders
# ------------------------
mkdir -p job-gpt-frontend/css
mkdir -p job-gpt-frontend/js
mkdir -p job-gpt-frontend/static/audio
mkdir -p job-gpt-frontend/static/images
mkdir -p job-gpt-frontend/static/fonts

# ------------------------
# Frontend index.html
# ------------------------
cat <<EOL > job-gpt-frontend/index.html
<!DOCTYPE html>
<html>
<head>
<title>Job-GPT</title>
<link rel="stylesheet" href="css/styles.css">
<script src="js/config.js"></script>
</head>
<body>
<h1>Job-GPT Frontend Placeholder</h1>
<p>This is the test frontend page.</p>
</body>
</html>
EOL

# Copy for dashboard.html
cp job-gpt-frontend/index.html job-gpt-frontend/dashboard.html

# ------------------------
# Frontend JS placeholders
# ------------------------
for js in config cv voice education; do
cat <<EOL > job-gpt-frontend/js/$js.js
console.log("$js.js placeholder loaded");
EOL
done

# ------------------------
# Frontend CSS
# ------------------------
cat <<EOL > job-gpt-frontend/css/styles.css
body { font-family: Arial, sans-serif; background-color: #f4f6f8; color: #333; }
h1 { color: #2c3e50; }
EOL

# ------------------------
# Placeholder audio
# ------------------------
touch job-gpt-frontend/static/audio/fake_audio.mp3

# ------------------------
# GitHub Actions workflow
# ------------------------
mkdir -p .github/workflows
cat <<EOL > .github/workflows/deploy.yml
name: Deploy Job-GPT

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: 3.11
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r job-gpt-backend/requirements.txt
      - name: Deploy to VPS
        uses: appleboy/ssh-action@v0.1.7
        with:
          host: \${{ secrets.VPS_HOST }}
          username: \${{ secrets.VPS_USER }}
          key: \${{ secrets.VPS_KEY }}
          script: |
            cd /home/jobgpt
            git pull origin main
            ./deploy_jobgpt.sh
EOL

echo "=================================================="
echo "✅ Job-GPT repo skeleton generated in folder 'job-gpt'"
echo "Next steps:"
echo "1. cd job-gpt"
echo "2. git init"
echo "3. git add ."
echo "4. git commit -m 'Initial commit - Job-GPT skeleton'"
echo "5. git branch -M main"
echo "6. git remote add origin https://github.com/<your-username>/job-gpt.git"
echo "7. git push -u origin main"
echo "8. Replace secrets and deploy via GitHub Actions"
echo "=================================================="

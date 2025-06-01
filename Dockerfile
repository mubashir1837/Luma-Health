# Base image with Python 3.11
FROM python:3.12-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg build-essential \
    libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libxext6 \
    libpng-dev libjpeg-dev libxml2-dev libxslt1-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p uploads/backend uploads/frontend uploads/skin_lesion_output uploads/speech data

# 🔁 Corrected port for Azure
EXPOSE 80

ENV PYTHONUNBUFFERED=1


HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80/health || exit 1


CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]


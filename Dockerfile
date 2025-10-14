FROM python:3.11-slim

# Install system dependencies required for OpenCascade
RUN apt-get update && apt-get install -y \
    build-essential cmake git wget \
    libglu1-mesa-dev freeglut3-dev mesa-common-dev \
    libfreetype6-dev libx11-dev libxext-dev libxt-dev libxrender-dev libxmu-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir pythonocc-core==7.6.1 numpy

# Copy application code
COPY app.py .

# Expose Flask port (Render uses $PORT automatically)
EXPOSE 5000

# Start the app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "--workers", "2", "--timeout", "120", "app:app"]

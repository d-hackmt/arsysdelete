FROM python:3.11-slim

# Python environment settings
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_SYSTEM_PYTHON=1

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN pip install --no-cache-dir uv

# Copy only requirements first (better Docker caching)
COPY requirements.txt .

# Install dependencies using uv
RUN uv pip install --system --no-cache -r requirements.txt

# Copy rest of the project
COPY . .

# Install project in editable mode (setup.py)
RUN uv pip install --system --no-cache -e .

# Streamlit port
EXPOSE 8501

# Run Streamlit app
CMD ["streamlit", "run", "app/app.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.headless=true"]

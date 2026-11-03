FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

# Instal curl untuk mendukung fitur Docker HEALTHCHECK
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

COPY app.py .
EXPOSE 5000

# Konfigurasi Docker Native Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["python", "app.py"]
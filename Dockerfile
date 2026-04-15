FROM python:3.12-slim

WORKDIR /app

RUN pip install --no-cache-dir uv==0.11.6

COPY requirements.lock .
RUN UV_EXCLUDE_NEWER="$(python -c "from datetime import datetime, timedelta, timezone; print((datetime.now(timezone.utc) - timedelta(days=7)).replace(microsecond=0).isoformat().replace('+00:00', 'Z'))")" \
    uv pip install --system --require-hashes -r requirements.lock

COPY . .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

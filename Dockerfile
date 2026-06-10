FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /app
RUN useradd --create-home appuser
COPY pyproject.toml README.md ./
COPY src ./src
COPY config ./config
RUN pip install --no-cache-dir -e .
COPY scripts ./scripts
USER appuser
EXPOSE 8000
CMD ["uvicorn", "iims.api.main:app", "--host", "0.0.0.0", "--port", "8000"]

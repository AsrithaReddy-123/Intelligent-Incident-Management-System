# Intelligent Incident Management System

Production-style AI incident management backend for automatic incident logging, NLP classification, severity prediction, SLA recommendation, ticket tracking, and recurring issue analytics.

## Features

- FastAPI REST service with OpenAPI documentation at `/docs`
- API key authentication and request rate limiting
- SQLAlchemy ticketing database with audit-ready incident records
- Text classification using Logistic Regression or Random Forest pipelines
- Optional BERT inference adapter when `transformers` and `torch` are installed
- Severity and SLA prediction based on category, urgency, and business impact
- K-Means and DBSCAN clustering for recurring incident discovery
- Structured JSON logging and Prometheus metrics endpoint
- Unit tests, linting, Dockerfile, Compose file, and GitHub Actions CI

## Repository structure

```text
src/iims/              Application package
tests/                 Unit and API tests
docs/                  API, architecture, security, and operations docs
config/                Runtime logging configuration
scripts/               Training, seed, and maintenance scripts
docker/                Container assets
.github/workflows/     CI pipeline
```

## Quick start

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
cp .env.example .env
python scripts/train_models.py --output-dir models
python scripts/seed_db.py
uvicorn iims.api.main:app --reload
```

Open `http://localhost:8000/docs` and authorize requests using the `X-API-Key` header from `.env`.

## Environment variables

| Variable | Default | Description |
| --- | --- | --- |
| `APP_NAME` | Intelligent Incident Management System | Service name |
| `ENVIRONMENT` | development | Environment label |
| `LOG_LEVEL` | INFO | Logging level |
| `DATABASE_URL` | sqlite:///./iims.db | SQLAlchemy database URL |
| `API_KEY` | change-this-secret-in-production | Required API key for protected endpoints |
| `MODEL_DIR` | ./models | Directory containing trained model artifacts |
| `DEFAULT_CLASSIFIER` | logistic_regression | `logistic_regression`, `random_forest`, or `bert` |
| `RATE_LIMIT_PER_MINUTE` | 120 | Per-client request limit |

## API examples

```bash
curl -X POST http://localhost:8000/incidents \
  -H "Content-Type: application/json" \
  -H "X-API-Key: change-this-secret-in-production" \
  -d '{
    "title":"VPN outage for sales team",
    "description":"Users in Mumbai cannot connect to VPN after password reset.",
    "urgency":"high",
    "impact":"department",
    "reported_by":"sales.ops@example.com"
  }'
```

```bash
curl -H "X-API-Key: change-this-secret-in-production" http://localhost:8000/incidents
curl -H "X-API-Key: change-this-secret-in-production" http://localhost:8000/analytics/clusters?k=4
curl http://localhost:8000/health
```

## Development workflow

```bash
ruff check src tests
mypy src
pytest
```

## Docker

```bash
docker compose up --build
```

## Security notes

- Use a strong `API_KEY` in production and rotate it regularly.
- Terminate TLS at a trusted reverse proxy or ingress controller.
- Store production secrets in a secret manager, not `.env` files.
- Restrict database credentials to minimum required permissions.
- Validate all incoming requests with Pydantic schemas.
- Run containers as non-root users.

## Model training

The training script builds realistic baseline classifiers from curated incident examples. It persists sklearn pipelines and metadata into `models/`.

```bash
python scripts/train_models.py --classifier logistic_regression --output-dir models
python scripts/train_models.py --classifier random_forest --output-dir models
```

Optional BERT support is exposed through `BertIncidentClassifier`. Install with:

```bash
pip install -e ".[bert]"
```

## License

MIT

FROM python:3.10-slim
ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.13
WORKDIR /usr/src/app
COPY poetry.lock pyproject.toml ./
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-dev --no-interaction --no-ansi
COPY src/* ./
ENV PYTHONUNBUFFERED=TRUE
ENV TZ='Europe/Rome'
EXPOSE 5000
CMD ["uvicorn", "backend:app", "--proxy-headers", "--port", "5000", "--host", "0.0.0.0"]
FROM library/python:3.9-slim as builder

RUN useradd mkdocs \
    --shell /bin/bash \
    --create-home
RUN pip3 install --upgrade pip
RUN pip3 --no-input install \
    --no-cache-dir \
    --progress-bar ascii \
    poetry

USER mkdocs
WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN poetry install

COPY mkdocs.yml ./

ARG PORT=8080
ENV PORT=$PORT
EXPOSE "$PORT"
CMD poetry run mkdocs serve \
    --strict \
    --config-file mkdocs.yml \
    --dev-addr "127.0.0.1:$PORT"

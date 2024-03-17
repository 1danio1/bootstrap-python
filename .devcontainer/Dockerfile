FROM mcr.microsoft.com/devcontainers/python:3.12

ENV POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local' \
    CURRENT_USER='vscode'

RUN mkdir ${POETRY_CACHE_DIR} && \
    chown ${CURRENT_USER}:${CURRENT_USER} ${POETRY_CACHE_DIR} && \
    curl -sSL https://install.python-poetry.org | python3 -

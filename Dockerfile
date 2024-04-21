
ARG PYTHON_VERSION=3.12.3
ARG UID=10001
ARG CURRENT_USER='appuser'

FROM python:${PYTHON_VERSION}-slim as builder

ARG UID
ARG CURRENT_USER

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local'

# https://medium.com/@albertazzir/blazing-fast-python-docker-builds-with-poetry-a78a66f5aed0

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${CURRENT_USER}"

RUN apt-get update && \
    apt-get -y install curl && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir ${POETRY_CACHE_DIR} && \
    chown ${CURRENT_USER}:${CURRENT_USER} ${POETRY_CACHE_DIR} && \
    curl -sSL https://install.python-poetry.org | python3 -

USER ${CURRENT_USER}

WORKDIR /app

COPY pyproject.toml poetry.lock README.md ./

RUN poetry install --without dev --no-root && \
    rm -rf $POETRY_CACHE_DIR/*

COPY . .

RUN poetry build --format wheel


FROM python:${PYTHON_VERSION}-slim as runner

ARG UID
ARG CURRENT_USER

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${CURRENT_USER}"

WORKDIR /app

COPY --from=builder /app/dist .

RUN pip install *.whl --no-cache-dir && \
    rm -f *.whl

USER ${CURRENT_USER}

CMD [ "python", "-m", "bootstrap_python" ]

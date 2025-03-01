
ARG PYTHON_VERSION=3.13.2
ARG ALPINE_VERSION=3.21
ARG UID=10001
ARG CURRENT_USER='appuser'
ARG WORKDIR='/app'

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG UID
ARG CURRENT_USER
ARG WORKDIR

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

RUN apk update && \
    apk upgrade && \
    apk add curl && \
    rm -rf /var/cache/apk/ && \
    rm -rf /var/lib/{dpkg,cache,log}/

RUN mkdir ${POETRY_CACHE_DIR} && \
    chown ${CURRENT_USER}:${CURRENT_USER} ${POETRY_CACHE_DIR} && \
    curl -sSL https://install.python-poetry.org | python3 -

USER ${CURRENT_USER}

WORKDIR ${WORKDIR}

COPY pyproject.toml poetry.lock README.md ./

RUN poetry install --without dev --no-root && \
    rm -rf $POETRY_CACHE_DIR/*

COPY . .

RUN poetry build --format wheel


FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS runner

ARG UID
ARG CURRENT_USER
ARG WORKDIR

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

RUN apk update && \
    apk upgrade && \
    apk add curl && \
    rm -rf /var/cache/apk/ && \
    rm -rf /var/lib/{dpkg,cache,log}/

COPY --from=builder ${WORKDIR}/dist ${WORKDIR}

RUN pip install ${WORKDIR}/*.whl --no-cache-dir && \
    rm -f ${WORKDIR}/*.whl \
    rm -rf ${WORKDIR}/

USER ${CURRENT_USER}

CMD [ "python", "-m", "bootstrap_python" ]

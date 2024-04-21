FROM mcr.microsoft.com/devcontainers/python:3.12

ENV POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    POETRY_HOME='/usr/local' \
    CURRENT_USER='vscode'

RUN apt-get update && \
    mkdir ${POETRY_CACHE_DIR} && \
    chown ${CURRENT_USER}:${CURRENT_USER} ${POETRY_CACHE_DIR} && \
    curl -sSL https://install.python-poetry.org | python3 -

# # Install docker
# ENV DOCKER_CHANNEL stable
# ENV DOCKER_VERSION 26.0.1
# ENV DOCKER_API_VERSION 1.45
# ENV DOCKER_COMPOSE_VERSION v2.26.1
# RUN curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" \
#     | tar -xzC /usr/local/bin --strip=1 docker/docker

# # RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/
# # RUN chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

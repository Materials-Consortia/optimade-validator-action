FROM materials-consortia/bats:1.11.0

ENV PYTHONUNBUFFERED 1
# Install Python 3
RUN apk add --update --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
# Install pip and pipx
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ENV BATS_TEST_HELPERS /test_helpers
# Install git and update BATS with bats-support and bats-assert
RUN apk add --no-cache git && \
    git clone https://github.com/bats-core/bats-support ${BATS_TEST_HELPERS}/bats-support && \
    git clone https://github.com/bats-core/bats-assert ${BATS_TEST_HELPERS}/bats-assert

# Imitate the Action's Dockerfile, retrieving the Docker host IP
RUN echo $(ip route | awk '{print $3}') > /docker_host_ip

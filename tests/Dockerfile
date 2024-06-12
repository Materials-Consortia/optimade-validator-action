FROM bats/bats:1.11.0

RUN echo "**** Installing Python 3 ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    echo "**** Installing pip ****" && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ENV BATS_TEST_HELPERS /test_helpers
RUN echo "**** Updating BATS with bats-support and bats-assert ****" && \
    apk add --no-cache git && \
    git clone https://github.com/bats-core/bats-support ${BATS_TEST_HELPERS}/bats-support && \
    git clone https://github.com/bats-core/bats-assert ${BATS_TEST_HELPERS}/bats-assert

RUN echo "**** Imitating the Action's Dockerfile, retrieving Docker host IP ****" && \
    echo $(ip route | awk '{print $3}') > /docker_host_ip

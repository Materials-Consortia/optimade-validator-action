FROM python:3.9-slim-buster

RUN apt update && apt install -y iproute2
RUN ["/bin/bash", "-c", "set -o pipefail && ip route | awk '{print $3}' > docker_host_ip"]

RUN python -m pip install --upgrade pip && \
    pip install setuptools wheel virtualenv

COPY helper.py /helper.py

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

FROM python:3.9

RUN set -o pipefail \
    echo $(ip route | awk '{print $3}') > /docker_host_ip

COPY helper.py /helper.py

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

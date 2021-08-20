FROM python:3.9-slim-buster

RUN apt update && apt install -y iproute2
CMD [ "bash" ]
RUN set -o pipefail && echo $(ip route | awk '{print $3}') > /docker_host_ip

COPY helper.py /helper.py

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

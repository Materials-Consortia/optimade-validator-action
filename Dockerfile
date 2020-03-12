FROM python:3.7

RUN echo $(ip route | awk '{print $3}') > /docker_host_ip

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

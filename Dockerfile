FROM python:3.9.0

RUN echo $(ip route | awk '{print $3}') > /docker_host_ip

COPY helper.py /helper.py

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

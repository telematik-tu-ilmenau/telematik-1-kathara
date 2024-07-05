FROM kathara/base

RUN apt update
RUN apt install -y \
    dnsmasq
RUN apt clean



RUN systemctl enable dnsmasq

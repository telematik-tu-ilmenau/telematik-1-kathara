FROM kathara/base

RUN apt update
RUN apt install -y \
    dnsmasq
RUN apt clean

COPY dnsmasq.conf /etc/dnsmasq.conf


RUN systemctl enable dnsmasq

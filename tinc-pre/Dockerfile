FROM alpine
MAINTAINER jack <jack@mobistor.com>

RUN apk add --no-cache iptables tinc-pre dhcp net-tools curl jq

COPY ./scripts/dhcp.sh /dhcp.sh
COPY ./scripts/init.sh /init.sh
COPY ./scripts/entrypoint.sh /entrypoint.sh
#COPY ./scripts/peer.sh /usr/local/bin/peer.sh
#COPY ./scripts/dhcpd.conf /etc/dhcp/

VOLUME /etc/tinc

RUN ["touch", "/var/lib/dhcp/dhcpd.leases"]

ENV NETNAME=net0 \
    DEVNAME=tun0 \
    KEYSIZE=2048 \
    CIPHER=none \
    COMPRESSION=10 \
    DIGEST=none \
    TCPONLY=no \
    STRICTSUBNETS=yes \
    VERBOSE=2

ENV ADDRESS=172.16.88.254 \
    NETMASK=255.255.255.0 \
    DHCP_DNS=8.8.8.8 \
    DHCP_START=172.16.88.1 \
    DHCP_END=172.16.88.253 \
    RUNMODE=server

EXPOSE 655/tcp 655/udp

ENTRYPOINT ["/entrypoint.sh"]

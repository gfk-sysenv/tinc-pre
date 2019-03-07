#!/bin/sh -e
cat > /etc/dhcp/dhcpd.conf <<_EOF_
authoritative;
default-lease-time 7200;
max-lease-time 7200;
subnet ${NETWORK} netmask ${NETMASK} {
        interface ${DEVNAME};
	option routers ${ADDRESS};
	option subnet-mask ${NETWORK};
	range ${DHCP_START} ${DHCP_END};
	option broadcast-address ${BROADCAST};
	option domain-name-servers ${DHCP_DNS};
}
_EOF_


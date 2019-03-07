#!/bin/sh -e

NETWORK=$(ipcalc -n $ADDRESS $NETMASK | cut -f 2 -d "=")
PREFIX=$(ipcalc -p $ADDRESS $NETMASK | cut -f 2 -d "=")
BROADCAST=$(ipcalc -b ${ADDRESS} ${NETMASK} | cut -f 2 -d "=")
SERVER=$(cat /sys/class/net/eth0/address | tr -d ":")
HOSTPORT=$(curl -s -X GET --unix-socket /var/run/docker.sock -H 'Content-Type: application/json' http://localhost/containers/$(hostname)/json | jq -r '.NetworkSettings.Ports | to_entries[] | .value[0].HostPort' | head -n 1 | tr -d "\n")

export NETWORK=${NETWORK}
export PREFIX=${PREFIX}
export BROADCAST=${BROADCAST}
export SERVER=${SERVER}
export HOSTPORT=${HOSTPORT}
echo -n ${HOSTPORT} > /etc/HOSTPORT

/dhcp.sh
/init.sh

if ! [[ -c /dev/net/tun ]]
then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

if [[ $RUNMODE = server ]]
then
    iptables -t nat -A POSTROUTING -s ${NETWORK}/${PREFIX} -o eth0 -j MASQUERADE
fi

exec tincd --no-detach \
           --net=${NETNAME} \
           --debug=${VERBOSE} \
           "$@"

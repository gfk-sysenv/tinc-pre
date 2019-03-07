#!/bin/sh -e
#
# initialize server profile
#

if [ -f /etc/tinc/${NETNAME}/hosts/${SERVER} ]
then
    echo 'Initialized!'
    exit 0
else
    echo 'Initializing...'
fi

mkdir -p /etc/tinc/${NETNAME}/hosts

cd /etc/tinc/${NETNAME}

cat > tinc.conf <<_EOF_
Name = ${SERVER} 
Interface = ${DEVNAME} 
AddressFamily = ipv4
GraphDumpFile = /var/log/tinc.net0.dot
Mode = switch
PrivateKeyFile = /etc/tinc/net0/rsa_key.priv
ExperimentalProtocol = no
logfile = /var/log/tinc.net0.log
StrictSubnets = ${STRICTSUBNETS}
_EOF_

cat > tinc-up <<_EOF_
#!/bin/sh
ip link set \$INTERFACE up
ifconfig \$INTERFACE ${ADDRESS} netmask ${NETMASK} broadcast ${BROADCAST} 
/usr/sbin/dhcpd -4 --no-pid -cf /etc/dhcp/dhcpd.conf
_EOF_

cat > tinc-down <<_EOF_
#!/bin/sh
ip addr del ${ADDRESS} dev \$INTERFACE
ip link set \$INTERFACE down
_EOF_


[ -f hosts/${SERVER} ] && rm -f hosts/${SERVER}
tinc  --net=${NETNAME} --batch generate-rsa-keys ${KEYSIZE} 
[ -f rsa_key.pub ] && mv rsa_key.pub hosts/${SERVER}

cat >> hosts/${SERVER} <<_EOF_
Cipher = ${CIPHER}
Compression = ${COMPRESSION}
Digest = ${DIGEST}
TCPOnly = ${TCPONLY} 
Address = ${ADDRESS}
Subnet = ${NETWORK}/${PREFIX}
_EOF_

chmod +x tinc-up tinc-down

tincd -n${NETNAME} < /dev/null

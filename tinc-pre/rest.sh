#!/bin/bash

case $1 in
  start)
    curl -XPOST --unix-socket /var/run/docker.sock http://localhost/containers/$2/start
  ;;
  stop)
    curl -XPOST --unix-socket /var/run/docker.sock http://localhost/containers/$2/stop
  ;;
esac

# curl --unix-socket /var/run/docker.sock http:/containers/cacb65292399/jso
# 7351c58bf4f843699d4fa83f7fc442e12f8233e452589d3f961eb7836a7e7c59

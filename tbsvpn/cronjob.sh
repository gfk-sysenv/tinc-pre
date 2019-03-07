#!/bin/bash

export VENDOR=tbsvpn
export ZONE=HongKong

start () 
{
  docker-compose up -d --scale tinc=5
}
stop ()
{
  docker-compose stop
  docker-compose rm -f
}
status()
{
  docker-compose ps
}
case $1 in
  status)
     status
     ;;
  stop)
     stop
     ;;
  start)
     stop
     start
     ;;
  *)
     start 
     ;;
esac


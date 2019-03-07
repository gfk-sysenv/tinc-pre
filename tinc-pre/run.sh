#!/bin/sh

docker run -d \
    --name tinc \
    --cap-add NET_ADMIN \
    tinc-pre:v3 

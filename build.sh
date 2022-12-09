#!/bin/bash
echo "Building docker container"
cd awrtc_signaling
docker build -t awrtc_signaling .
cd ..



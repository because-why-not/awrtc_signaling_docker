#!/bin/bash
echo "Building docker container"
cd awrtc_signaling
npm install
npm run build
docker build -t awrtc_signaling .
cd ..



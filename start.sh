#!/bin/bash
. ./env.sh
${docker_compose} up -d awrtc_signaling

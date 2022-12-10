#!/bin/bash
. ./env.sh
#uncomment to force renewal for testing
#$cert_args="--force-renewal"
echo "Getting a lets encrypt certificate"
${docker_compose} run --rm --entrypoint "\
  certbot renew \
  --deploy-hook \"touch /etc/letsencrypt/updated && chmod 666 /etc/letsencrypt/updated\"\
  ${cert_args}" certbot

#check if it exists
if [ ! -f "./data/letsencrypt/updated" ];
then
  #no new certificate. exit
  exit 0
fi
#new certificate. restart
echo "Certificates updated. Restarting server"
rm ./data/letsencrypt/updated
./stop.sh && ./start.sh
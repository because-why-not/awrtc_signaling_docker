#!/bin/bash
. ./env.sh
#uncomment to force renewal for testing
#cert_args="--force-renewal --break-my-certs"
echo "Checking for new lets encrypt certificate"
${docker_compose} run --rm --entrypoint "\
  certbot renew \
  --deploy-hook \"touch /etc/letsencrypt/updated && chmod 666 /etc/letsencrypt/updated\"\
  ${cert_args}" certbot
docker_error_code=$?

if [ ! $docker_error_code -eq 0 ]; then
  echo "docker compose failed with error code $docker_error_code"
  exit 1
fi

#check if it exists
if [ ! -f "./data/letsencrypt/updated" ];
then
  #no new certificate. exit
  echo "No new certificate"
  exit 0
fi
#new certificate. restart
echo "Certificates updated. Restarting server"
rm ./data/letsencrypt/updated
./stop.sh && ./start.sh

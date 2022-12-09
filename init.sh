#!/bin/bash
#script will initialize the docker containers with a valid let's encrypt 
#SSL certificate
#usage for production:
# domain=your.domain.com email=your_email@example.com ./init.sh
#
#usage for testing
# domain=your.domain.com email=your_email@example.com cert_args=--staging ./init.sh
#
#Note let's encrypt has limits for how often you can try to get a valid certificate
#Use the testing command for experimentation/debugging (but even this might have limits)

echo "Init using domain: ${domain}, email: ${email} and additional flags: ${cert_args}"

if [ -z ${domain+x} ];
then
   echo "domain not set!"
   exit 1
fi
if [ -z ${email+x} ];
then
   echo "email not set!"
   exit 1
fi

cert_target_dir="./data/certbot/conf/live/$domain"
certbot_rsa_key_size=4096

if [ -d "${cert_target_dir}" ];
then
  echo "Certbot folder already exists. Stopping to avoid overwriting an existin certificate. Remove the ./data folder first to restart from scratch!" >&2
  exit 1
fi

echo "Generating data folder from template"
mkdir -p data
cp ./template/config.json ./data/config.json
cp -r ./template/public ./data/public

echo "Insert domain name into the config.json"
sed -i "s/__DOMAIN_NAME__/${domain}/g" ./data/config.json

echo "Copy dummy init certificates to ${cert_target_dir}"
mkdir -p ${cert_target_dir}
cp ./awrtc_signaling/out/ssl.crt ${cert_target_dir}/fullchain.pem
cp ./awrtc_signaling/out/ssl.key ${cert_target_dir}/privkey.pem

echo "Starting awrtc_signaling"
docker-compose up --force-recreate -d awrtc_signaling
#wait a bit to ensure it is fully booted up
sleep 5
#we remove the folder again to not interfere with certbot
rm -rf "${cert_target_dir}"

echo "Getting a lets encrypt certificate"
docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $cert_args \
    --email $email \
    -d $domain \
    --rsa-key-size $certbot_rsa_key_size \
    --agree-tos \
    --force-renewal" certbot

#shut server down again. Once start is triggered it will boot up using
#the new certificates
docker-compose down
echo "Init complete. Use ./start.sh to run. "
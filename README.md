# Introduction
This project containerizes awrtc_signaling and combines it with certbot and a few scripts to manage SSL certificates.

# Requirements
You need:
* basic understanding of the linux command line, ssh and docker
* a linux server with docker and docker-compose installed (tested with ubuntu 22) 
* a public domain that points to your servers IP address
* an open TCP port 80 and 443

# Setup

1. Download the source code using git clone --recursive https://github.com/because-why-not/awrtc_signaling_docker
2. cd awrtc_signaling_docker All other commands below must be executed from the project folder.
3. Run ./build.sh to build the docker container. 
4. Then run the init script to get your first SSL certificate e.g.:
domain=your.domain.com email=your_email@example.com ./init.sh


# Usage
Use ./start.sh to run the server and ./stop.sh to shutdown. 

Test via https://your.domain.com . It should print "Running ...". 

You can customize the config.json via data/awrtc_signaling/config.json 

# Automatic renewal

Certificates from letsencrypt are usually valid for 3 months and will get updated after 2 months if requested. 
To update the certificate if available call ./renew.sh regularly. This can be done via crontab on linux:

To edit the crontab file call:

crontab -e

Then add a line to run a script periodically:
e.g. The line below will trigger it every day at 7:41 am. 
41 7 * * * cd /path/to/your/folder && ./renew.sh 2>&1 | logger


# Problems

Problem: The init script failed and now it returns an error if I try again:

Delete the data folder and then try again. 

Problem: The renewal didn't work correctly. 

To force a renewal for testing call:
cert_args="--force-renew --break-my-certs" ./renew.sh
or uncomment the cert_args line in renew.sh


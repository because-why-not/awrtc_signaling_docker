# Introduction
This project containerizes awrtc_signaling and combines it with certbot and a few scripts to manage SSL certificates.

# Requirements
You need:
* basic understanding of the linux command line, ssh and docker
* a linux server with docker and docker-compose installed (tested with ubuntu 22) 
* a public domain that points to your servers IP address
* an open TCP port 80 and 443

# Setup
Run the commands below after logging into your server. This assumes docker & git are already installed. 
```bash
#Download the source code
git clone --recursive https://github.com/because-why-not/awrtc_signaling_docker
# enter project dir. All other commands below must be executed from this folder
cd awrtc_signaling_docker
#build docker container for awrtc_signaling
./build.sh

#run the init script to get your first SSL certificate
domain=your.domain.com email=your_email@example.com ./init.sh\
```

# Usage
Use `./start.sh` to run the server and `./stop.sh` to shutdown and cleanup the docker containers. 

After starting you can test the server by visiting your own domain e.g.: https://your.domain.com . It should print "Running ...". 

You can customize the config.json via data/awrtc_signaling/config.json .

# Automatic renewal

Certificates from letsencrypt are usually valid for 3 months and will get updated after 2 months if requested. 
To update the certificate if available call ./renew.sh regularly. This can be done via crontab on linux:

To edit the crontab file call:

crontab -e

Then add a line to run a script periodically:
e.g. The line below will trigger it every day at 7:41 am. 


`41 7 * * * cd /path/to/your/folder && ./renew.sh 2>&1 | logger`


# Problems

Get logs via docker compose e.g.: `docker compose logs -f --tail 100`. This will show the last 100 lines of log and automatically follow any new log generated. 

## Problem: The init script failed and now it returns an error if I try again:
Delete the data folder and then try again. 



## Problem: The renewal didn't work correctly. 
To force a renewal for testing call:
`cert_args="--force-renew --break-my-certs" ./renew.sh`
or uncomment the cert_args line in renew.sh. This can be used for testing. Just note letsencrypt has a limit how often you can do this. 




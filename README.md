# Introduction
This project containerizes awrtc_signaling and combines it with the docker version of certbot to automate the SSL setup process.

# Requirements
You need:
* basic understanding of the linux command line, ssh and docker
* a linux server with docker and docker-compose installed
* a public domain that points to your servers IP address
* an open TCP port 80 and 443

# Setup
Download the source code using git clone --recursive 
Run ./build.sh to build the docker container. 
Then run the init script to get your first SSL certificate e.g.:
domain=your.domain.com email=your_email@example.com ./init.sh

# Running
Use ./start.sh to run the server and ./stop.sh to shutdown. 

Test via https://your.domain.com . It should print "Running ...". 

# Automatic renewal
TODO

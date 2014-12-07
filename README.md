si-docker
=========

Managing installations of simple-invoices with Docker.

### Installing the container

 1. Install docker: `apt-get install docker.io`
 2. Get the code of the project from github: `git clone https://github.com/FreeSoft-AL/si-docker /data/invoices`
 3. Build a docker image for simple invoices: `/data/invoices/docker-build.sh`
 4. Create a new container for invoices: `/data/invoices/docker-create.sh`
 5. Start and stop this container with: `docker start invoices`, `docker stop invoices`, `docker restart invoices`.
    Put `docker start invoices` on `/etc/rc.local` in order to start it automatically on server reboot.
    
You can remove the container and the image with `/data/invoices/docker-rm.sh`.

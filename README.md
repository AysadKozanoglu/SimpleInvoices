si-docker
=========

Managing installations of simple-invoices with Docker.

### Installing the container

 1. Install docker: `apt-get install docker.io`
 2. Get the code of the project from github:
    ```
    git clone https://github.com/FreeSoft-AL/si-docker /data/invoices
    ```
 3. Build a docker image for simple invoices: `/data/invoices/docker-build.sh`
 4. Create a new container for invoices: `/data/invoices/docker-create.sh`
 5. Start and stop this container with: `docker start invoices`, `docker stop invoices`, `docker restart invoices`.
    Put `docker start invoices` on `/etc/rc.local` in order to start it automatically on server reboot.
    
You can remove the container and the image with `/data/invoices/docker-rm.sh`.

### Install a new domain

Create a config file for the domain `/data/invoices/domains/test.sh` with a content like this:
``` bash
domain=test.example.com
email=user@example.com
password=testpwd
sample=true
```

Install a new copy of simple invoices for this domain:
``` bash
cd /data/invoices/
./site-add.sh invoices domains/test.sh
```

Now you can open in browser `test.example.org` and `m.test.example.org` and login with username `user@example.com` and password `testpwd`.

This domain can be deleted with: `/data/invoices/site-del.sh invoices test.example.org`

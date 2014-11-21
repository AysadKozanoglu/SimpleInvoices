#!/bin/bash

container=${1:-invoices}

### remove the container and its base image
docker stop $container
docker rm $container
docker rmi $container

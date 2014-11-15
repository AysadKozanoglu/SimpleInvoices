#!/bin/bash

cd $(dirname $0)
docker run -d --name=invoices -p 80:80 -p 443:443 \
           -v $(pwd):/data invoices

#!/bin/bash -x
### Create a new container for invoices.

### set some variables
container="invoices"
domain="si.example.org"

### create a new container
docker create --name="$container" --hostname="$domain" \
    -v /data/invoices:/app:ro invoices

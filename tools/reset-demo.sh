#!/bin/bash -x
### Reset the demo site.

### go to the script directory
cd $(dirname $0)

### delete the demo site
./site-del.sh demo.si.fs.al

### install it again from scratch
./site-add.sh ../clients/demo.sh


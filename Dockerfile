
FROM ubuntu-upstart:14.04

### Install packages.
COPY packages.sh /tmp/
RUN DEBIAN_FRONTEND=noninteractive /tmp/packages.sh

### Copy the source code and install.
COPY . /usr/local/src/invoices/
ENV code_dir /usr/local/src/invoices
WORKDIR /usr/local/src/invoices/
RUN ["install.sh"]


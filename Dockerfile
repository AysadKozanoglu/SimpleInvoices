
FROM ubuntu-upstart:14.04

### Install packages.
COPY install/packages.sh /tmp/
RUN /tmp/packages.sh

### Install the application.
COPY install/inv.sh /tmp/
RUN /tmp/inv.sh

### Config the system.
COPY . /app/
RUN /app/install/config.sh

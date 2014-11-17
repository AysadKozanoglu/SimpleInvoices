
FROM ubuntu-upstart:14.04

### Install packages.
COPY install/packages.sh /tmp/
RUN /tmp/packages.sh

### Install the application.
COPY install/simpleinv.sh /tmp/
RUN /tmp/simpleinv.sh

### Config the system.
COPY . /app/
RUN /app/install/{config.sh,settings.sh}

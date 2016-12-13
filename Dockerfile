# This is a Dockerfile for creating a Manet container from a base Ubuntu 14:04 image.
# Manet's code can be found here: https://github.com/vbauer/manet
#
# To use this container, start it as usual:
#
#    $ sudo docker run pdelsante/manet
#
# Then find out its IP address by running:
#
#    $ sudo docker ps
#    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
#    d1d7165512e2        pdelsante/manet     "/usr/bin/manet"    48 seconds ago      Up 47 seconds       8891/tcp            romantic_cray
#
#    $ sudo docker inspect d1d7165512e2 | grep IPAddress
#         "IPAddress": "172.17.0.1",
#
# Now you can connect to:
#    http://172.17.0.1:8891
#
FROM ubuntu:16.04
MAINTAINER pietro.delsante_AT_gmail.com
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 8891

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install curl && \
    curl -sL https://deb.nodesource.com/setup_6.x | /bin/bash - && \
    apt-get -y install nodejs build-essential libfontconfig1 xvfb firefox && \
    npm install -g phantomjs-prebuilt slimerjs manet && \
    sed -ie 's/letter/A4/g' /usr/lib/node_modules/manet/src/scripts/screenshot.js && \
    curl -Lo /usr/local/sbin/init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
    chmod a+x /usr/local/sbin/init

ENTRYPOINT ["/usr/local/sbin/init", "/usr/bin/manet", "--command=timeout -s9 30 xvfb-run -a slimerjs", "--cache=0", "--cleanupStartup=true", "--cleanupRuntime=true", "--cors=true", "--force=true"]

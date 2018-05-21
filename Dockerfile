# Download base image
FROM openjdk:8-jre

# Define the ARG variables for creating docker image
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

# Labels
LABEL org.label-schema.name="Traccar" \
      org.label-schema.description="OpenJDK Debian based Traccar image" \
      org.label-schema.vendor="Paul NOBECOURT <paul.nobecourt@orange.fr>" \
      org.label-schema.url="https://github.com/pnobecourt/" \
      org.label-schema.version=$VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/pnobecourt/docker-traccar" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0"

# Define the ENV variable for creating docker image
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL=/bin/bash
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV TRACCAR_VERSION 3.16
ENV TRACCAR_VOL /opt/traccar

# Install additional repositories
RUN echo "deb http://www.deb-multimedia.org stretch main non-free" | tee -a /etc/apt/sources.list.d/debian-multimedia.list && \
    apt-get update ; \
    apt-get install -y --allow-unauthenticated deb-multimedia-keyring && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

# Install supervisor and copy supervisor's configuration file
RUN apt-get update && \
    apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install Traccar dependency
RUN apt-get update && \
    apt-get -y install \
            curl \
            unzip \
            wget \
            && \
    apt-get clean && \
    rm -rf \
           /tmp/* \
           /var/lib/apt/lists/* \
           /var/tmp/*

# Install Traccar
RUN set -ex && \
    wget -O /tmp/traccar.zip https://github.com/tananaev/traccar/releases/download/v$TRACCAR_VERSION/traccar-other-$TRACCAR_VERSION.zip && \
    unzip -qo /tmp/traccar.zip -d $TRACCAR_VOL && \
    rm /tmp/traccar.zip

# Ports configuration
EXPOSE 8082 5000-5150 5000-5150/udp

# Start PGM
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]

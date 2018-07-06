# Download base image
FROM barbak/alpine-s6:latest

# Define the ARG variables
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
ARG TRACCAR_VERSION=3.17

# Labels
LABEL org.label-schema.name="Traccar" \
      org.label-schema.description="Alpine based Traccar Docker image" \
      org.label-schema.vendor="Paul NOBECOURT <paul.nobecourt@orange.fr>" \
      org.label-schema.url="https://github.com/pnobecourt/" \
      org.label-schema.version=$VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/pnobecourt/docker-traccar" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0"

# Define the ENV variables
ENV INSTALL_LOCATION=/srv/traccar \
CONF_LOCATION=${INSTALL_LOCATION}/conf \
DATA_LOCATION=${INSTALL_LOCATION}/data \
LOGS_LOCATION=${INSTALL_LOCATION}/logs \
DOWNLOAD_LOCATION=/tmp/downloads \
CONF_TMP=/tmp/conf

# Install Traccar
RUN apk update && \
    apk add --no-cache \
        curl \
        unzip \
        openjdk8-jre && \
    mkdir -p $INSTALL_LOCATION $DOWNLOAD_LOCATION && \
    curl -L -S https://github.com/tananaev/traccar/releases/download/v$TRACCAR_VERSION/traccar-other-$TRACCAR_VERSION.zip -o $DOWNLOAD_LOCATION/traccar-other-$TRACCAR_VERSION.zip && \
    unzip -qo $DOWNLOAD_LOCATION/traccar-other-$TRACCAR_VERSION.zip -d $INSTALL_LOCATION && \
    cp $CONF_LOCATION/* $CONF_TMP/ && \
    rm $DOWNLOAD_LOCATION/traccar-other-$TRACCAR_VERSION.zip && \
    apk del --no-cache curl unzip

# Add files
ADD /root /

# Define Workdir
WORKDIR $INSTALL_LOCATION

# Ports configuration
EXPOSE 8082 5000-5150 5000-5150/udp

# Entrypoint
ENTRYPOINT [ "/init" ]

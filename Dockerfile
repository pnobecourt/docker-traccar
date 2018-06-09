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
ENV TRACCAR_VOL=/srv/apps/traccar

# Install Traccar
RUN apk update && \
    apk add --no-cache \
        curl \
        unzip \
        openjdk8-jre && \
    curl -L -S https://github.com/tananaev/traccar/releases/download/v$TRACCAR_VERSION/traccar-other-$TRACCAR_VERSION.zip -o /tmp/traccar.zip && \
    mkdir -p $TRACCAR_VOL && \
    unzip -qo /tmp/traccar.zip -d $TRACCAR_VOL && \
    mkdir -p $TRACCAR_VOL/init-conf && \
    cp $TRACCAR_VOL/conf/* $TRACCAR_VOL/init-conf/ && \
    rm /tmp/traccar.zip && \
    apk del --no-cache curl unzip

# Add files
ADD /root /

# Define Workdir
WORKDIR $TRACCAR_VOL

# Ports configuration
EXPOSE 8082 5000-5150 5000-5150/udp

# Entrypoint
ENTRYPOINT [ "/init" ]

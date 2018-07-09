# Traccar

This is an Alpine based Traccar Docker image.

WORK IN PROGRESS / NOT USEABLE

Create workdirs :

     mkdir -p /path/to/your/traccar/volume/conf /path/to/your/traccar/volume/data /path/to/your/traccar/volume/logs

Create container :

    docker run -d \
               --init \
               --restart always \
               --name traccar \
               --hostname traccar \
               -p 8082:8082/tcp
               -p 5000-5150:5000-5150/tcp
               -p 5000-5150:5000-5150/udp
               -v /etc/timezone:/etc/timezone:ro \
               -v /etc/localtime:/etc/localtime:ro \
               -v /path/to/your/traccar/volume/conf:/opt/traccar/conf:rw \
               -v /path/to/your/traccar/volume/data:/opt/traccar/data:rw \
               -v /path/to/your/traccar/volume/logs:/opt/traccar/logs:rw \
               barbak/traccar

Or docker-compose :

    version: "3.6"
    services:
        # Traccar - Traccar server
        traccar:
            container_name: traccar
            hostname: traccar
            image: barbak/traccar
            restart: always
            ports:
                - "8082:8082/tcp"
                - "5000-5150:5000-5150/tcp"
                - "5000-5150:5000-5150/udp"
            volumes:
                - /etc/timezone:/etc/timezone:ro
                - /etc/localtime:/etc/localtime:ro
                - /path/to/your/traccar/volume/conf:/opt/traccar/conf:rw
                - /path/to/your/traccar/volume/data:/opt/traccar/data:rw
                - /path/to/your/traccar/volume/logs:/opt/traccar/logs:rw

The web interface runs on port 8082.

List of exposed ports : 8082/tcp 5000-5150/tcp 5000-5150/udp

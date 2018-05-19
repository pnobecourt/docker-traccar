# traccar

This is a OpenJDK Debian-based Traccar Docker image.

Create workdirs :

     mkdir -p /path/to/your/traccar/volume/conf /path/to/your/traccar/volume/data /path/to/your/traccar/volume/logs

Get default default.xml :

    docker run --rm \
               --entrypoint cat barbak/traccar \
               /opt/traccar/conf/default.xml > /path/to/your/traccar/volume/conf/default.xml

Get default traccar.xml :

    docker run --rm \
               --entrypoint cat barbak/traccar \
               /opt/traccar/conf/traccar.xml > /path/to/your/traccar/volume/conf/traccar.xml

Edit traccar.xml: https://www.traccar.org/configuration-file/

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
               -v /path/to/your/traccar/volume/conf/default.xml:/opt/traccar/conf/default.xml:ro \
               -v /path/to/your/traccar/volume/conf/traccar.xml:/opt/traccar/conf/traccar.xml:ro \
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
                - /path/to/your/traccar/volume/conf/default.xml:/opt/traccar/conf/default.xml:ro
                - /path/to/your/traccar/volume/conf/traccar.xml:/opt/traccar/conf/traccar.xml:ro
                - /path/to/your/traccar/volume/data:/opt/traccar/data:rw
                - /path/to/your/traccar/volume/logs:/opt/traccar/logs:rw

The web interface runs on port 8082.

List of exposed ports : 8082/tcp 5000-5150/tcp 5000-5150/udp

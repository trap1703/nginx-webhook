FROM ubuntu:16.04

ADD build.sh /tmp/

RUN cd /tmp && sh /tmp/build.sh && rm -rf /tmp/*

WORKDIR /opt/nginx

EXPOSE 80 443 8080

VOLUME ["/var/log/nginx", "/var/www/html"]

CMD sh
#CMD ["nginx", "-g", "daemon off;"]

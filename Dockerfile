FROM ubuntu:16.04

ADD build.sh /tmp/

RUN cd /tmp && sh /tmp/build.sh && rm -rf /tmp/*

WORKDIR /opt/nginx
ADD index.html /opt/nginx/html/
ADD nginx.conf /opt/nginx/

RUN nginx -V

EXPOSE 80 443 8080


RUN /usr/sbin/nginx

CMD sh
#CMD ["nginx", "-g", "daemon off;"]

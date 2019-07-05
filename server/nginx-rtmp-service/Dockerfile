# https://hub.docker.com/r/tiangolo/nginx-rtmp
FROM tiangolo/nginx-rtmp

WORKDIR /
RUN echo "------ hello current working dir is: $PWD"
COPY radio_nginx_stunnel.conf /etc/nginx/nginx.conf
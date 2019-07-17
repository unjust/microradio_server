FROM buildpack-deps:stretch

RUN apt-get update
RUN apt-get install -y ca-certificates openssl libssl-dev && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install -y stunnel4

RUN mkdir /etc/stunnel/conf.d

COPY stunnel.conf /etc/stunnel/stunnel.conf
COPY fb.conf /etc/stunnel/conf.d/fb.conf
EXPOSE 19350 

CMD ["stunnel4"]

FROM buildpack-deps:stretch

RUN apt-get update && \
    apt-get install -y ca-certificates openssl libssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get install -y stunnel4

RUN cat <<EOF > /etc/stunnel/stunnel.conf 
RUN  setuid = stunnel4
RUN setgid = stunnel4
RUN pid=/tmp/stunnel.pid
RUN output = /var/log/stunnel4/stunnel.log
RUN include = /etc/stunnel/conf.d
RUN EOF

RUN cat <<EOF > /etc/stunnel/conf.d/fb.conf 
RUN [fb-live]
RUN client = yes
RUN accept = 0.0.0.0:19350
RUN connect = live-api-s.facebook.com:443
RUN verifyChain = no
RUN EOF

EXPOSE 19350
CMD ["stunnel", "/etc/stunnel/stunnel.conf"]
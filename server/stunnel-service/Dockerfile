FROM buildpack-deps:stretch

RUN apt-get update
RUN apt-get install -y ca-certificates openssl libssl-dev && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install -y stunnel4

RUN mkdir /etc/stunnel/conf.d

# RUN echo $'cat <<EOF > /etc/stunnel/stunnel.conf \n \
# setuid = stunnel4 \n \
# setgid = stunnel4 \n \
# pid=/tmp/stunnel.pid \n \
# output = /var/log/stunnel4/stunnel.log \n \
# include = /etc/stunnel/conf.d \n \
# EOF'


# RUN echo $'cat <<EOF > /etc/stunnel/conf.d/fb.conf  \n \
# [fb-live] \n \ 
# client = yes \n \
# accept = 19350 \n \
# connect = live-api-s.facebook.com:443 \n \
# verifyChain = no \n \
# EOF'

COPY stunnel.conf /etc/stunnel/stunnel.conf
COPY fb.conf /etc/stunnel/conf.d/fb.conf

EXPOSE 19350
# CMD ["stunnel4"]
CMD ["stunnel4", "/etc/stunnel/stunnel.conf"]
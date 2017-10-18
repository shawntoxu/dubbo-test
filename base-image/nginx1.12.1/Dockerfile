FROM xxx:5000/paas/ubuntu-sshd:1.0.2

MAINTAINER paas/shawn.wang

RUN \ 
     apt-get update && apt-get install -y python-software-properties  software-properties-common \
     && add-apt-repository ppa:nginx/stable \
     && apt-get update \
     && apt-get install -y  nginx \
     && rm -rf /var/lib/apt/lists/* \
     && sed -i s/768/10000/g /etc/nginx/nginx.conf 
  


EXPOSE 80 22

CMD service nginx start; /usr/sbin/sshd -D




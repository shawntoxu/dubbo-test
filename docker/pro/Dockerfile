FROM jdk:1.8.0_131

MAINTAINER paas/shawn.wang

ADD ./pro  /app/run/process/pro
ADD ./start_app.sh /root/start_app.sh

#EXPOSE 8080
EXPOSE 9200

CMD ["/bin/sh","-c","/root/start_app.sh"]


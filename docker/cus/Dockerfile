FROM jdk:1.8.0_131

MAINTAINER paas/shawn.wang

ADD ./cus  /app/run/process/cus
ADD ./start_app.sh /root/start_app.sh

EXPOSE 8080

CMD ["/bin/sh","-c","/root/start_app.sh"]


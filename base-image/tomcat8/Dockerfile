FROM xxx:5000/jdk:1.8.0_131

MAINTAINER paas/shawn.wang

ADD ./apache-tomcat-8.5.14 ./app/tomcat8

ENV TOMCAT8=/app/tomcat8

WORKDIR $TOMCAT8

EXPOSE 8080

CMD bin/catalina.sh run

#/usr/sbin/sshd -D



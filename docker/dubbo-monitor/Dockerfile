FROM tomcat:8.5.14

ADD ./ROOT $TOMCAT8/webapps/ROOT 
ADD ./start_app.sh /root/start_app.sh 

CMD ["/bin/sh","-c","/root/start_app.sh"]


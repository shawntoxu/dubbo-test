#! /bin/bash
export PATH=/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin
set -e 
java 2>/var/log/javaerror  || source /etc/profile  

echo "tomcat8 dir is "$TOMCAT8
APP_CONFIG=$TOMCAT8/webapps/ROOT/WEB-INF/dubbo.properties
sed -i s/10.12.46.10:2181/${ZK_ADDRESS}/g $APP_CONFIG
sed -i s/ecnetwork-dubbo/${DUBBO_GROUP}/g $APP_CONFIG

# start services and as a daemon
cd $TOMCAT8/bin  && ./startup.sh 
#&& ./catalina.sh run
/usr/sbin/sshd -D

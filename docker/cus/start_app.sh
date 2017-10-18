#! /bin/bash
export PATH=/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin
set -e 
java 2>/var/log/javaerror  || source /etc/profile  
  
BIN_DIR=/app/run/process/cus/bin

# start services and as a daemon
cd ${BIN_DIR} && ./start.sh
/usr/sbin/sshd -D

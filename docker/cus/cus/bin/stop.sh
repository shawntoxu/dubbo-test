#!/bin/bash
cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`
LOCK_FILE=$DEPLOY_DIR/bin/config_restart.lock
CONF_DIR=$DEPLOY_DIR/conf

SERVER_NAME='dubboservices'

if [ -z "$SERVER_NAME" ]; then
    SERVER_NAME=$CONF_DIR
fi

PIDS=`ps -ef | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ -z "$PIDS" ]; then
    echo "ERROR: The $SERVER_NAME does not started!"
    exit 1
fi

#dump
if [ "$1" != "skip" ]; then
    $BIN_DIR/dump.sh
fi

echo -e "Stopping the $SERVER_NAME ...\c"
echo 'STOP' > $LOCK_FILE

#COUNT=0
#while [ $COUNT -lt 1 ]; do
#    echo -e ".\c"
#    sleep 1
#    COUNT=1
#    for PID in $PIDS ; do
#        PID_EXIST=`ps -f -p $PID | grep java`
#        if [ -n "$PID_EXIST" ]; then
#            COUNT=0
#            break
#        fi
#    done
#done

COUNT=0
while true ; do
    echo -e ".\c"
    sleep 1
    if [ ! -f "$LOCK_FILE" ]; then
        break;
    fi
    COUNT=`expr $COUNT + 1`
    if [ $COUNT -ge 300 ]; then
        break;
    fi
done
echo "OK"

#!/bin/bash
cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf
LOCK_FILE=$DEPLOY_DIR/bin/config_restart.lock

SERVER_NAME=$BIN_DIR
LOGS_FILE=""

if [ -z "$SERVER_NAME" ]; then
	SERVER_NAME=`hostname`
fi

PIDS=`ps -ef | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ -z "$PIDS" ]; then
    echo "not ok"
    exit 1
fi

if [ ! -f "$LOCK_FILE" ]; then
    echo "not ok"
    exit 1
fi

STARTED=`cat $LOCK_FILE |grep 'STARTED'|awk '{print $1}'`
if [[ $STARTED'x' = 'STARTEDx' ]]; then
    echo 'ok'
    exit 0
else
    echo 'not ok'
    exit 1
fi


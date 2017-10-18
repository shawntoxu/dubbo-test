#!/bin/bash

JAVA_HOME=/app/soft/jdk1.8.0_131
PATH=$PATH:$JAVA_HOME/bin
export PATH
export ZK_ADDRESS=10.18.46.40:2181,10.18.146.40:2181,10.18.146.41:2181
export PATH=$PATH:$ZK_ADDRESS

export NODEJS_HOME=/app/soft/node-v6.10.2-linux-x64
export PATH=$PATH:$NODEJS_HOME/bin

export PHANTOMJS_HOME=/app/soft/node_modules/phantomjs
export PATH=$PATH:$PHANTOMJS_HOME/bin
export CASPERJS_HOME=/app/soft/node_modules/casperjs
export PATH=$PATH:$CASPERJS_HOME/bin

cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`
SERVICE_NAME=`basename $DEPLOY_DIR`
HOSTIP=`ip a|grep inet|grep eth0|awk '{print $2}'|awk -F '/' '{print $1}'`
LOGS_DIR="/app/logs/$HOSTIP/$SERVICE_NAME"
PASS_LOGS_DIR="/app/logs/$SERVICE_NAME"
mkdir -p $LOGS_DIR
CONF_DIR=$DEPLOY_DIR/conf
SERVER_NAME=`hostname`
SERVER_PROTOCOL=``

if [ -z "$SERVER_NAME" ]; then
    SERVER_NAME=`hostname`
fi

if [ ! -d $LOGS_DIR ]; then
    mkdir $LOGS_DIR
fi

ERROR_OUT_FILE=$LOGS_DIR/errorout.out
LIB_DIR=$DEPLOY_DIR/lib
LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'|tr "\n" ":"`

JAVA_OPTS=" -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dlogback.configurationFile=$CONF_DIR/logback.xml -DLOGS_DIR=$LOGS_DIR -DPASS_LOGS_DIR=$PASS_LOGS_DIR"

JAVA_JMX_OPTS=""
if [ "$1" = "jmx" ]; then
    JAVA_JMX_OPTS=" -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false "
fi
JAVA_MEM_OPTS=""
BITS=`java -version 2>&1 | grep -i 64-bit`

if [ -n "$BITS" ]; then
    JAVA_SERVICE_MEN=""
    if [ "$SERVICE_NAME"x = "ecnetwork-controller"x ];then
        JAVA_SERVICE_MEN=" -server -Xmx1600m -Xms512m -Xmn128m "
    elif [ "$SERVICE_NAME"x = "ecnetwork-core-service"x ];then
        JAVA_SERVICE_MEN=" -server -Xmx3g -Xms512m -Xmn256m -XX:MaxMetaspaceSize=128m -Xss256k "
    elif [ "$SERVICE_NAME"x = "ecnetwork-db-service"x ];then
        JAVA_SERVICE_MEN=" -server -Xmx1536m -Xms512m -Xmn256m -XX:MaxMetaspaceSize=128m -Xss256k "
    elif [ "$SERVICE_NAME"x = "ecnetwork-scheduler"x ];then
        JAVA_SERVICE_MEN=" -server -Xmx2600m -Xms2600m  -XX:MaxMetaspaceSize=128m -Xss256k "
    elif [ "$SERVICE_NAME"x = "ecnetwork-shop"x ];then
        JAVA_SERVICE_MEN=" -server -Xmx2600m -Xms2600m  -XX:MaxMetaspaceSize=128m -Xss256k "
    elif [ "$SERVICE_NAME"x = "ecnetwork-mq-service"x ];then
        JAVA_SERVICE_MEN=" -server -Xmx2600m -Xms2600m  -XX:MaxMetaspaceSize=128m -Xss256k "
    else
        echo 'not found services '$SERVICE_NAME
        exit 1;
    fi
    JAVA_MEM_OPTS=$JAVA_SERVICE_MEN" -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "
    echo $JAVA_MEM_OPTS
else
    JAVA_MEM_OPTS=" -server -Xms1g -Xmx1g -XX:MaxMetaspaceSize=128m -XX:SurvivorRatio=2 -XX:+UseParallelGC "
fi
JAVA_DEBUG_OPTS=""
if [ "$ENABLE_JAVA_DEBUG" = "Y" ];then
	JAVA_DEBUG_PORT="9201"
	if [ "$SERVICE_NAME"x = "ecnetwork-controller"x ];then
        JAVA_DEBUG_PORT="9201"
    elif [ "$SERVICE_NAME"x = "ecnetwork-core-service"x ];then
        JAVA_DEBUG_PORT="9202"
    elif [ "$SERVICE_NAME"x = "ecnetwork-db-service"x ];then
        JAVA_DEBUG_PORT="9203"
    elif [ "$SERVICE_NAME"x = "ecnetwork-scheduler"x ];then
        JAVA_DEBUG_PORT="9204"
    elif [ "$SERVICE_NAME"x = "ecnetwork-shop"x ];then
        JAVA_DEBUG_PORT="9205"
    elif [ "$SERVICE_NAME"x = "ecnetwork-mq-service"x ];then
        JAVA_DEBUG_PORT="9206"
    else
        echo 'not found services '$SERVICE_NAME
        exit 1;
    fi
    JAVA_DEBUG_OPTS=" -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address="${JAVA_DEBUG_PORT}",server=y,suspend=n "
fi
JAVA_GC_OPTS=" -verbose:gc -XX:+PrintGCDetails -XX:+PrintHeapAtGC -Xloggc:$LOGS_DIR/gc.log "
JAVA_JPROFILER_OPTS=" -agentpath:/app/jprofiler/jprofiler8/bin/linux-x64/libjprofilerti.so=port=8849,nowait -Xbootclasspath/a:/app/jprofiler/jprofiler8/bin/agent.jar "

SPRINGBOOT_OPTS="springboot"

result=$(echo $BIN_DIR | grep "ecnetwork-controller\|ecnetwork-shop")
if [ "$result" != "" ];
then
   echo 'is web services ,start built-in tomcat'
  SPRINGBOOT_OPTS="springbootweb"
else
    SPRINGBOOT_OPTS="springboot"
fi

echo $SPRINGBOOT_OPTS
echo -e "Starting the $SERVER_NAME ...\c"
nohup java $JAVA_OPTS $JAVA_MEM_OPTS $JAVA_GC_OPTS $JAVA_DEBUG_OPTS $JAVA_JMX_OPTS -classpath $CONF_DIR:$LIB_JARS com.alibaba.dubbo.container.Main $SPRINGBOOT_OPTS >/dev/null 2>$ERROR_OUT_FILE &

PIDS=`ps -f | grep java | grep "$DEPLOY_DIR" | awk '{print $2}'`
echo "PID: $PIDS"
echo "LOGS_DIR: $LOGS_DIR"

echo "OK!"
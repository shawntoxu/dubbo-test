#!/bin/bash

. /etc/profile
. ~/.bash_profile

cd `dirname $0`
DEPLOY_DIR=`pwd`
LOCK_FILE=$DEPLOY_DIR/config_restart.lock

echo "$LOCK_FILE"
if [ -f "$LOCK_FILE" ];
then
   echo "lock file exist ,exec restart.sh"
  ./start.sh
else
    datevar=`date +%Y%m%d-%H:%M:%S`
   echo "lock file check by $datevar"
fi


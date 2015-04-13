#!/bin/sh

### BEGIN INIT INFO
# Provides:          wsparser
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the wsparser backend
# Description:       starts the wsparser backend 
### END INIT INFO



# Source function library.
. /lib/lsb/init-functions
. /lib/init/vars.sh

. /etc/backend/wsparser.conf

PIDFILE="/var/run/starman.$PROJECT_NAME.pid"
APP="$APP_PATH/bin/app.psgi"

ARGS="\
	--pid $PIDFILE \
	--user www-data \
	--workers $WORKERS_COUNT \
	--error-log /var/log/starman/$PROJECT_NAME.error.log \
	--access-log /var/log/starman/$PROJECT_NAME.access.log \
	--port $PORT \
	--max-requests $MAX_REQUESTS \
	-R $APP_PATH/lib -D
	"

if [ -z "$APP" ]; then
    echo "Can't proceed, \$APP not defined"
    exit 1
fi

running() {
    if [ ! -r ${PIDFILE} ]; then
        return 1
    fi
    kill -0 `cat ${PIDFILE}`
    return $?
}

start() {
    if running; then
        PID=`cat ${PIDFILE}`
        echo "$PROJECT_NAME already running (pid $PID from ${PIDFILE}), can't start"
        exit 1
    fi

	echo -n "Starting $PROJECT_NAME: "
	$STARMAN $ARGS $APP
	RETVAL=$?

    [ $RETVAL = 0 ] || echo 'FAIL'
    return $RETVAL
}

apptest() {
    echo -n "Checking $PROJECT_NAME startup: "
    su -s /bin/bash $USER -c "$RUN_ENV $APP"
    if [ "$?" != "0" ] ; then
        echo "Application test failed"
		exit $?
    fi
    echo "OK"
}

restart() {
    if ! running; then
        echo "$PROJECT_NAME not running, can't restart"
        exit 1
    fi
    echo -n "Restarting $PROJECT_NAME: "
    apptest
    stop
    start
}

stop() {
    if ! running; then
        echo "$PROJECT_NAME not running, can't stop"
        exit 1
    fi
    echo -n "Stopping $PROJECT_NAME: "
    kill -s QUIT `cat ${PIDFILE}`
    RETVAL=$?
    echo
     [ $RETVAL = 0 ] && rm -f ${PIDFILE}
     [ $RETVAL = 0 ] && echo "OK"
}

case "$1" in
  start)
    start
    ;;
  restart)
    restart
    ;;
  stop)
    stop
    ;;
  apptest)
   ;;
  *)

  echo "Usage: $PROJECT_NAME {start|restart|stop|apptest}"
  exit 1
esac

exit $RETVAL


#!/bin/bash

/usr/local/bin/confd -onetime -backend env

# Initialize JDBCConfig module for first time
if [ ! -f ${GEOSERVER_DATA_DIR}/jdbcconfig/jdbcconfig.properties ]; then 
    cp ${GEOSERVER_DATA_DIR}/jdbcconfig/jdbcconfig_init.properties ${GEOSERVER_DATA_DIR}/jdbcconfig/jdbcconfig.properties 
fi

# test if we already configured this container, only configure it once
if [ ! -f ${CATALINA_HOME}/conf/default_config_set ]; then
    bash /opt/geoserver_config.sh &
fi

# Make sure all fonts in volumes are available
fc-cache -f -v

exec catalina.sh run

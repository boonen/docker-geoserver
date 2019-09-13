#!/bin/bash

/usr/local/bin/confd -onetime -backend env

# Make sure all fonts in volumes are available
fc-cache -f -v

exec catalina.sh run

#!/usr/bin/env bash

# Define your path to marlin library:
export MARLIN_PATH=$CATALINA_HOME/lib/marlin-$MARLIN_MAJOR_VERSION-Unsafe-OpenJDK9.jar
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/tomcat/lib
export JRE_HOME=$JAVA_HOME
export GDAL_DATA=$GDAL_DATA

JAVA_OPTS="$JAVA_OPTS -Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine \
                      -Dsun.java2d.renderer.profile=speed \
                      -Dorg.geoserver.wms.featureinfo.minBuffer=$WMS_FEATUREINFO_MIN_BUFFER \
                      -Djava.library.path=$LD_LIBRARY_PATH \
                      -DGDAL_DATA=$GDAL_DATA \
                      -DGEOSERVER_DATA_DIR=$GEOSERVER_DATA_DIR \
                      -DGEOSERVER_REQUIRE_FILE=$GEOSERVER_DATA_DIR/global.xml \
                      -server \
                      -Djava.awt.headless=true \
                      -Dfile.encoding=UTF-8 \
                      -Djava.security.egd=file:/dev/./urandom \
                      -XX:InitialRAMPercentage=$JVM_HEAP_INITIAL_RAM_PERCENTAGE \
                      -XX:MaxRAMPercentage=$JVM_HEAP_MAX_RAM_PERCENTAGE \
                      -XX:+UseG1GC \
                      -XX:+DisableExplicitGC \
                      -XX:+UseStringDeduplication \
                      -XX:+OptimizeStringConcat \
                      -XX:+ExitOnOutOfMemoryError \
                      -XX:+UseContainerSupport \
                      -XX:+IdleTuningGcOnIdle \
                      -Xbootclasspath/a:$MARLIN_PATH \
                      -Xshareclasses \
                      -Xtune:virtualized \
                      -Xscmx96m \
                      -Xscmaxaot10m \
                      -Xshareclasses:cacheDir=/opt/shareclasses \
                      -Xquickstart"
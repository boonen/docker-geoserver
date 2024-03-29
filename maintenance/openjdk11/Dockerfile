FROM tomcat:9-jdk11-openjdk-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
    sed -i 's/main/main contrib/' /etc/apt/sources.list && \
    apt-get update && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt-get install -y ttf-mscorefonts-installer fontconfig && \
    apt-get autoremove -y && \ 
    rm -rf /var/lib/apt/lists/*
    
ENV CONFD_VERSION 0.16.0
ENV GEOSERVER_DOWNLOAD_URL https://downloads.sourceforge.net/project/geoserver/GeoServer
ENV GEOSERVER_VERSION 2.15.3
ENV GEOSERVER_PLUGINS control-flow excel libjpeg-turbo wps vectortiles imagemosaic-jdbc sldservice
ENV GEOSERVER_COMMUNITY_PLUGINS_DOWNLOAD_URL https://build.geoserver.org/geoserver
ENV GEOSERVER_COMMUNITY_PLUGINS ""
ENV POSTGRESQL_JDBC_VERSION 42.2.6
ENV HIKARICP_VERSION 3.3.1
ENV MARLIN_MAJOR_VERSION 0.9.4.2
ENV MARLIN_MINOR_VERSION jdk9
ENV LIBJPEG_TURBO_VERSION 2.0.2
ENV GEOSERVER_DATA_DIR /var/data/geoserver
ENV LD_LIBRARY_PATH /usr/lib/jni:/usr/local/lib:/usr/lib:/opt/libjpeg-turbo/lib64:/usr/local/tomcat/native-jni-lib:/usr/local/tomcat/lib:$LD_LIBRARY_PATH

SHELL ["/bin/bash", "-ceux"]

RUN export CURL_OPTS=(-sfSL --retry 3) && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y curl unzip apt-utils debconf && \
    curl ${CURL_OPTS[@]} -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 && \
    chmod +x /usr/local/bin/confd && \
    curl ${CURL_OPTS[@]} -o ${CATALINA_HOME}/lib/HikariCP-${HIKARICP_VERSION}.jar https://search.maven.org/remotecontent?filepath=com/zaxxer/HikariCP/${HIKARICP_VERSION}/HikariCP-${HIKARICP_VERSION}.jar && \
    rm -rf ${CATALINA_HOME}/webapps/* && \
    curl ${CURL_OPTS[@]} -o ${CATALINA_HOME}/lib/marlin-${MARLIN_MAJOR_VERSION}-Unsafe-OpenJDK9.jar https://github.com/bourgesl/marlin-renderer/releases/download/v$(echo ${MARLIN_MAJOR_VERSION}_${MARLIN_MINOR_VERSION} | sed -e "s/\./\_/g")/marlin-${MARLIN_MAJOR_VERSION}-Unsafe-OpenJDK9.jar && \
    cd /tmp && \
    curl ${CURL_OPTS[@]} -o geoserver.zip "${GEOSERVER_DOWNLOAD_URL}/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip" && \
    unzip -q geoserver.zip -d geoserver && unzip -q geoserver/geoserver.war -d ${CATALINA_HOME}/webapps/ROOT/ && \
    rm -rf $CATALINA_HOME/webapps/ROOT/data/ && \
    rm -rf geoserver.zip geoserver && \
    mv $CATALINA_HOME/webapps/ROOT/WEB-INF/lib/{log4j,slf4j}-* ${CATALINA_HOME}/lib/ && \
    for plugin in $GEOSERVER_PLUGINS; do \
      curl ${CURL_OPTS[@]} -o geoserver-plugin.zip ${GEOSERVER_DOWNLOAD_URL}/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-${plugin}-plugin.zip; \
      unzip -q -o geoserver-plugin.zip -d ${CATALINA_HOME}/webapps/ROOT/WEB-INF/lib/; \
      rm geoserver-plugin.zip; \
    done && \
    GEOSERVER_BRANCH_VERSION=${GEOSERVER_VERSION%.*} && \
    for plugin in $GEOSERVER_COMMUNITY_PLUGINS; do \
      curl ${CURL_OPTS[@]} -o geoserver-plugin.zip ${GEOSERVER_COMMUNITY_PLUGINS_DOWNLOAD_URL}/${GEOSERVER_BRANCH_VERSION}.x/community-latest/geoserver-${GEOSERVER_BRANCH_VERSION}-SNAPSHOT-${plugin}-plugin.zip; \
      unzip -q -o geoserver-plugin.zip -d ${CATALINA_HOME}/webapps/ROOT/WEB-INF/lib/; \
      rm geoserver-plugin.zip; \
    done && \
    curl ${CURL_OPTS[@]} -o ${CATALINA_HOME}/lib/postgresql-${POSTGRESQL_JDBC_VERSION}.jar https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_JDBC_VERSION}.jar && \
    curl ${CURL_OPTS[@]} -o /tmp/libjpeg-turbo.deb https://downloads.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_TURBO_VERSION}/libjpeg-turbo-official_${LIBJPEG_TURBO_VERSION}_amd64.deb && \
    dpkg -i libjpeg-turbo.deb && \
    ln -s /opt/libjpeg-turbo/lib64/libjpeg.so.62.0.0 /usr/lib/libjpeg.so.62 && \
    rm libjpeg-turbo.deb && \
    apt-get purge -y apt-utils && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY --from=boonen/gdal4geoserver:latest /usr-local-lib.tgz /
COPY --from=boonen/gdal4geoserver:latest /usr/share/java/gdal.jar /usr/share/java/gdal.jar
COPY --from=boonen/gdal4geoserver:latest /usr/local/share/gdal/ /usr/local/share/gdal/

RUN export CURL_OPTS="-sSL --retry 3" && \
    export DEBIAN_FRONTEND=noninteractive && \
    tar --absolute-names -xf /usr-local-lib.tgz && \
    rm /usr-local-lib.tgz && \
    for plugin in "gdal"; do \
      curl ${CURL_OPTS[@]} -o geoserver-plugin.zip ${GEOSERVER_DOWNLOAD_URL}/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-${plugin}-plugin.zip; \
      unzip -q -o geoserver-plugin.zip -d ${CATALINA_HOME}/webapps/ROOT/WEB-INF/lib/; \
      rm -f ${CATALINA_HOME}/webapps/ROOT/WEB-INF/lib/imageio-ext-gdal-bindings-*.jar; \
      rm -f ${CATALINA_HOME}/webapps/ROOT/WEB-INF/lib/gdal*.jar; \
      cp /usr/share/java/gdal.jar ${CATALINA_HOME}/webapps/ROOT/WEB-INF/lib/; \
      rm geoserver-plugin.zip; \
    done
    
# Turn off Tomcat access logging
RUN sed -i 's/<Valve className="org.apache.catalina.valves.AccessLogValve"/\<\!\-\-<Valve className="org.apache.catalina.valves.AccessLogValve/' conf/server.xml && \
    sed -i 's/pattern="%h %l %u %t &quot;%r&quot; %s %b" \/>/pattern="%h %l %u %t &quot;%r&quot; %s %b" \/>-->/' conf/server.xml

COPY assets/tomcat_logging.properties /usr/local/tomcat/conf/logging.properties
COPY assets/entrypoint.sh /entrypoint.sh
COPY assets/setenv-openjdk.sh /usr/local/tomcat/bin/setenv.sh
COPY assets/confd /etc/confd
COPY assets/data /var/data/geoserver

VOLUME ["/var/data/geoserver"]

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

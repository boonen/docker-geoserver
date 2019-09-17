# GeoServer in Docker

This repository delivers an opinionated, ready-to-use build of [GeoServer](https://www.geoserver.org), the open source 
mapping server. In comparison with the default distribution (as available from http://geoserver.org/release/stable/) this
image has the following changes:

* No demo data
* No pre-configured layers, workspaces, styles, etc.
* Optimized JVM configuration for production on Docker and Kubernetes hosting
* Optional JNDI connection pool using [HikariCP](https://github.com/brettwooldridge/HikariCP)
* PostgreSQL and PostGIS drivers
* Marlin Rasterizer
* LibJPEG Turbo library
* MS core fonts
* Installed modules:
    * [JDBC Config](https://docs.geoserver.org/latest/en/user/community/jdbcconfig/index.html)
    * [Control Flow](https://docs.geoserver.org/latest/en/user/extensions/controlflow/index.html)
    * charts
    * [Excel](https://docs.geoserver.org/latest/en/user/extensions/excel.html)
    * [libjpeg-turbo](https://docs.geoserver.org/latest/en/user/extensions/libjpeg-turbo/index.html)
    * wps
    * csw
    * [Vector Tiles](https://docs.geoserver.org/latest/en/user/extensions/vectortiles/index.html)
    * [Importer](https://docs.geoserver.org/latest/en/user/extensions/importer/index.html)
    * [SLD REST Service](https://docs.geoserver.org/latest/en/user/extensions/sldservice/index.html)
    * [Backup and Restore](https://docs.geoserver.org/latest/en/user/community/backuprestore/index.html)

This repository always delivers GeoServer stable, maintenance and beta versions based on tje Java 11 distributions of 
OpenJ9 and OpenJDK. The version and JVM type can be found in the image tag:

* latest -> current stable version running on OpenJDK
* stable-openjdk
* stable-openj9
* maintenance-openjdk
* maintenance-openj9
* beta-openjdk
* beta-openj9

### Which version to choose?

If you're concerned about memory usage, choose the OpenJ9 versions (it uses ~ 30-40% less RAM). Otherwise go with the 
OpenJDK versions.

## Getting started

Use the following Docker command to start the server:

    docker run --name geoserver -p 8080:8080 boonen/geoserver:latest
    
### Configuring your container

*TODO: add documentation on available `ENV` variables.*

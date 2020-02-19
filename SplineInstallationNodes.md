# Spline Installation notes

## Getting the files

```bash
wget https://repo1.maven.org/maven2/za/co/absa/spline/admin/0.4.1/admin-0.4.1.jar
wget https://repo1.maven.org/maven2/za/co/absa/spline/spark-agent-bundle-2.3/0.4.1/spark-agent-bundle-2.3-0.4.1.jar
wget https://repo1.maven.org/maven2/za/co/absa/spline/rest-gateway/0.4.1/rest-gateway-0.4.1.war
wget https://repo1.maven.org/maven2/za/co/absa/spline/client-web/0.4.1/client-web-0.4.1.war
```

Also, get the corresponding .sha1 hash files, and check the calculated value is correct (sha1sum $filename displays the hash value).

## Installing ArangoDB

* Using the Community Edition from https://www.arangodb.com/download-major/redhat/

* Installed using Yum:
  ```bash
  cd /etc/yum.repos.d/
  curl -OL https://download.arangodb.com/arangodb36/RPM/arangodb.repo
  yum -y install arangodb3-3.6.1
  ```

* Change the default root password (seems to be necessary to ensure that the system database is correctly set up). I just used the same service account password that all the Hadoop services were using. 
  ```bash
  arango-secure-installation
  ```
  whatever password you set, we'll refer to it as `$ARANGO_DB_PWD` below. 

* Enable/start the arangodb service 
  ```bash
  systemctl enable arangodb3.service
  systemctl start arangodb3.service
  ```

* Start the shell to check everything is working
  ```bash
  arangosh
  ```

* Create the Spline database
  ```bash
  java -jar admin-0.4.1.jar db-init arangodb://root:$ARANGO_DB_PWD@localhost/spline
  ```

* Spline is just a bunch of Java Servlet WebApis (albeit written in Scala), so we'll need to install a servlet container - e.g. Apache Tomcat
  ```bash
  sudo yum install tomcat.noarch
  ```

* ZDP has already grabbed port 8080 and a few others for its services, so we'll need to run on another port: I chose 8079. Change the setting in `/etc/tomcat/conf/server.xml`:
  ```xml
  <Connector port="8079" 
             protocol="HTTP/1.1"
             connectionTimeout="20000"
             redirectPort="8443" />
  ```

* Need to pass the ArangoDb connection string to the webapp, so add 
  ```properties
  JAVA_OPTS="-Dspline.database.connectionUrl=arangodb://root:$ARANGO_DB_PWD@localhost/spline"
  ``` 
  to `/usr/share/tomcat/conf/tomcat.conf`

* copy the rest-gateway war file that we downloaded earlier to /usr/share/tomcat/webapps, and rename it to `spline-rest-gateway.war`. The name of the `.war` becomes the prefix in the url served by tomcat for that app, so it will be easier if we don't have to worry about version numbers for now. 

* Start tomcat
  ```bash
  sudo systemctl start tomcat
  ```

* Browse to http://cluster3-node-zdp-0:8079/spline-rest-gateway/about/version. It should just return a json string containing the version details. E.g.
  ```json
  {"build":{"timestamp":"2019-12-16T13:36:05Z","version":"0.4.1"}}
  ```
  If you get an HTTP error, check in `var/log/tomcat.$TODAY.log` where $TODAY is the ISO8601 date (2020-02-18 at the time of writing) and look for errors.

* Stop Tomcat (can't remember if it does hot-reloads or not)

* Copy the client-web war to the Tomcat webapps folder (renaming it again)
  ```bash
  sudo cp client-web-0.4.1.war /usr/share/tomcat/webapps/spline-client.war
  ```

* Add a new line to `/usr/share/tomcat/conf/tomcat.conf` which needs to  match the url of the rest gateway service:
  ```properties
  JAVA_OPTS="-Dspline.consumer.url=http://$HOSTNAME:8079/spline-rest-gateway/consumer"
  ```

* Restart Tomcat
* Browse to cluster3-node-zdp-0:8079/spline-client/ - you should get a nice page saying that there is no lineage to display. 



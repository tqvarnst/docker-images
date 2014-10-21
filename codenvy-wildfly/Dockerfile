FROM codenvy/jdk7

RUN mkdir /home/user/wildfly && \
    wget \
    -qO- \
    "http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz" | tar -zx --strip-components=1 -C /home/user/wildfly/
RUN cd /home/user/wildfly/standalone/configuration/ && \  
  	 sed -i 's/<location name="\/" handler="welcome-content"\/>//g' standalone.xml


ADD $app$ /home/user/wildfly/standalone/deployments/ROOT.war


EXPOSE 8080
ENV CODENVY_APP_PORT_8080_HTTP 8080

WORKDIR /home/user/wildfly/bin/
CMD ./standalone.sh -b 0.0.0.0
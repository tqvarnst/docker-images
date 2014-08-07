FROM    centos:centos6

MAINTAINER psteiner <psteiner@redhat.com>
MAINTAINER ssadeghi <ssadeghi@redhat.com>

# Update the system and Install necessary RPMs
RUN yum -y update && \ 
 yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel unzip openssh-server openssh-clients  && \
 yum clean all

# Make sure JAVA_HOME is set
ENV JAVA_HOME /usr/lib/jvm/jre

# Set root password
RUN echo "root:redhat" | /usr/sbin/chpasswd

# Create user to run JBoss EAP
RUN useradd -m -d /home/jbosseap -p jbosseap jbosseap 

# Install JBoss EAP 6.2.0
USER jbosseap

ENV HOME /home/jbosseap
RUN mkdir $HOME/eap && \
 mkdir $HOME/tmp
   
ADD . $HOME/tmp/

RUN /usr/bin/unzip -q $HOME/tmp/jboss-eap-6.2.*.zip -d $HOME/eap 

# Add admin user admin=admin-123
RUN echo "admin=31d47addbf45f5c23eb6419f6d1176b8" >> $HOME/eap/jboss-eap-6.2/standalone/configuration/mgmt-users.properties

#Clean Up
RUN rm $HOME/tmp/*

CMD $HOME/eap/jboss-eap-6.2/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0

EXPOSE 8080 9990


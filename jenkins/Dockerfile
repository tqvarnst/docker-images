#######################################################################
#                                                                     #
# Creates a base CentOS image with Jenkins							  #
#                                                                     #
#######################################################################

# Use the centos base image
FROM centos
MAINTAINER Thomas Qvarnstrom <tqvarnst@redhat.com>


USER root
# Update the system
RUN yum -y update;yum clean all




##########################################################
# Install Java JDK, SSH and other useful cmdline utilities
##########################################################
RUN yum -y install java-1.7.0-openjdk-devel which telnet unzip openssh-server sudo openssh-clients iputils iproute httpd-tools wget; yum clean all
ENV JAVA_HOME /usr/lib/jvm/jre
#RUN chkconfig sshd on
#RUN service sshd start

# Create jboss user with password "jboss"
#RUN useradd -m -d /home/jboss -p "2yfRR9.I3eJac" jenkins

# enabling sudo group for jboss
# RUN echo '%jboss ALL=(ALL) ALL' >> /etc/sudoers

# Increase ulimit
#RUN echo "* soft nofile 4096" >> /etc/security/limits.conf
#RUN echo "* hard nofile 4096" >> /etc/security/limits.conf



############################################
# Install Jenkins
############################################
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
RUN rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum -y install jenkins


RUN cp /etc/sysconfig/jenkins /etc/sysconfig/jenkins.save
RUN sed -i 's/^JENKINS_ARGS=.*/JENKINS_ARGS="--prefix=\/jenkins"/' /etc/sysconfig/jenkins

RUN wget -O /etc/yum.repos.d/epel-apache-maven.repo http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo

RUN yum -y install apache-maven

RUN service jenkins start

EXPOSE 8080

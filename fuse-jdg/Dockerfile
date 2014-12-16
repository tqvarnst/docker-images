#######################################################################
#                                                                     #
# Creates a base CentOS image with JBoss Fuse						  #
#                                                                     #
#######################################################################
FROM    jboss-fuse:6.1.1

MAINTAINER tqvarnst <tqvarnst@redhat.com>


############################################
# Add local maven repo
############################################
USER jboss

ENV HOME /home/jboss
WORKDIR $HOME

ADD jboss-datagrid-6.4.0.Beta-maven-repository.zip $HOME/
ADD settings.xml $HOME/

# Unzip the local repo files
RUN unzip -q jboss-datagrid-6.4.0.Beta-maven-repository.zip
RUN cp -f settings.xml .m2/settings.xml

#######################################################################                               
# Clean up															  #
#######################################################################
RUN rm -f jboss-datagrid-6.4.0.Beta-maven-repository.zip


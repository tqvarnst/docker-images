#######################################################################
#                                                                     #
# Creates a Jenkins image with TicketMonster job configured  		  #
#                                                                     #
#######################################################################

FROM jenkins
MAINTAINER Siamak Sadeghianfar <ssadeghi@redhat.com>

# Maven settings
ADD settings.xml /var/lib/jenkins/maven-settings.xml

# Dev job
RUN mkdir -p /var/lib/jenkins/jobs/ticket-monster-dev
ADD ticket-monster-dev-job.xml /var/lib/jenkins/jobs/ticket-monster-dev/config.xml

# Test job
RUN mkdir -p /var/lib/jenkins/jobs/ticket-monster-test
ADD ticket-monster-test-job.xml /var/lib/jenkins/jobs/ticket-monster-test/config.xml

# Set the permissions
RUN chown -R jenkins:jenkins /var/lib/jenkins

# Utilities
RUN wget -O /tmp/jq http://stedolan.github.io/jq/download/linux64/jq 
RUN chmod +x /tmp/jq
RUN cp /tmp/jq /usr/bin
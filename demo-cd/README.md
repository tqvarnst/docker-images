Continuous Delivery Docker Demo
=============

This script creates a docker-based continuous delivery environment by setting up a Jenkins and Nexus docker container. Jenkins is pre-configured to use Nexus as the maven repository and contains build jobs for the t[https://github.com/siamaksade/ticket-monster](https://github.com/siamaksade/ticket-monster) project. The build job builds new docker images containing JBoss EAP and the built artifacts.  

Usage:
```
$ ./cli.sh build all
$ ./cli.sh start
```

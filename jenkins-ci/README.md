Jenkins Docker Container
=========================

A docker image based on jenkins which installs "Build Pipeline" plugin and configures two build jobs for building the [https://github.com/siamaksade/ticket-monster](https://github.com/siamaksade/ticket-monster) project:

**ticket-monster-dev**: builds and deploys the artifacts to Nexus
**ticket-monster-test**: pulls the artifacts from Nexus, builds and starts a docker image containing the artifacts deployed on JBoss EAP.

Usage: 
```
$ docker build -t jenkins-ci .
$ docker run -d -p=8000:8080 jenkins-ci
```

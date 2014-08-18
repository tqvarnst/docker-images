Docker Images
=============

This repository contains docker images for:

* JBoss EAP
* Jenkins Base
* Jenkins CI (added plugins and jobs for demo)
* Sonatype Nexus
* SonarQube

Use the cli script in demo-cd in order to setup a CD environment based on the above components. 

Instructions
=============
Build a docker image

```
$ cd [image_name]
$ docker build -t [image_name] .
```

Start a docker container in detached mode
```
$ docker run -d -P [image_name]
```

Demo 
=============
Look at demo-cd for further instructions how to setup a Continueous Delivery environment using the included docker containers.

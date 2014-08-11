JBoss EAP Docker Container
=========================

###Required external files###

Before running the docker command to create the image, you will have to download Red Hat JBoss EAP v6.3 from the Red Hat support page or from http://www.jboss.org and copy into this folder.

###Usage###
```
$ docker build -t eap .
$ docker run -d -p 8080:8080 -p 9990:9990 eap
```

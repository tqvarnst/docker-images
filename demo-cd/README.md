Continuous Delivery Using Docker Containers
=============

This script creates a docker-based continuous delivery environment by setting up Jenkins, Nexus and Sonar in separate docker containers. Jenkins is pre-configured to use Nexus as the maven repository and contains build jobs for the [ticket-monster](https://github.com/siamaksade/ticket-monster) project. The build job builds new docker images containing JBoss EAP with TicketMonster deployed on it.  

![Continuous Delivery with Docker](https://raw.githubusercontent.com/tqvarnst/docker-images/master/demo-cd/images/cd-docker.png)


Build Pipeline
=============

![Build Pipeline](https://raw.githubusercontent.com/tqvarnst/docker-images/master/demo-cd/images/pipeline.png)

The build pipline in this demo is consisted of the following stages:

* Dev
  * clone from github
  * compile
  * run unit tests
  * deploy to Nexus
* Sonar
  * clone from github
  * run static code analysis
* System Test
  * fetche artifacts from Nexus
  * create docker image for the artifacts based on EAP, deploy artifacts and execute the Puppet manifest for configuration
  * start a container based on the creatd docker image
  * run the tests
  * stop the docker container
  
The docker image and container created during the test stage is available afterwards for further investigations by the test team.

![Docker Images](https://raw.githubusercontent.com/tqvarnst/docker-images/master/demo-cd/images/docker-images.png)

![Docker Containers](https://raw.githubusercontent.com/tqvarnst/docker-images/master/demo-cd/images/docker-containers.png)

Configuration Management
=============

Masterless puppet is used for applying configuration to the containers. A [Puppet manifest](https://github.com/tqvarnst/ticket-monster/blob/2.6.x-develop/demo/src/conf/appconfig.pp) is added to TicketMonster which contains the configurations needed for the application. The Puppet manifest is executed when building the applicaiton docker image in order to configure the image as desired by the application.


Instructions
=============
Build all images
```
$ ./cli.sh build all
```
Build individual images
```
$ ./cli.sh build jenkins
$ ./cli.sh build nexus
```
Start all containers
```
$ ./cli.sh start all
```
Start individual components
```
$ ./cli.sh start sonar
```
Stop all
```
$ ./cli.sh stop all
```
Help instructions
```
$ ./cli.sh help
```

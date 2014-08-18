#!/bin/sh
#
# Created by Siamak Sadeghianfar <ssadeghi@redhat.com>
# Inspired by Juergen Hoffmann <buddy@redhat.com>
#
#
# This script builds all required docker images.
# 

function build_image { 
  IMAGE=$1
  pushd ../$IMAGE >/dev/null
  docker build -q --rm -t $IMAGE .
  popd > /dev/null

}

function remove_image {
  IMAGE=$1

  for IMAGE_ID in $(docker images | grep -w $IMAGE | awk '{ print $3; }')
  do
    # Only try removing the images if there is a pre-built image
    if [ ! -z "$IMAGE_ID" ]; then

    echo "Removing $IMAGE_ID"

      if [ $(docker ps -a | grep $IMAGE_ID | awk '{ print $1; }' | wc -l) -gt 0 ]; then
        # remove all running and stopped containers based of the image
        docker rm -f $(docker ps -a | grep $IMAGE_ID | awk '{ print $1; }')
      fi

      if [ $(docker ps -a | grep $IMAGE | awk '{ print $1; }' | wc -l) -gt 0 ]; then
        # In case we still have the named reference
        docker rm -f $(docker ps -a | grep $IMAGE | awk '{ print $1; }')
      fi

      # finally remove the image
      docker rmi -f $IMAGE_ID
    fi
  done
}

function remove_container {
  CONTAINER_ID=$(docker ps -a | grep $1 | awk '{ print $1; }')

  if [ ! -z "$CONTAINER_ID" ]; then
    docker rm -f $CONTAINER_ID
  fi
}

function stop_container {
  CONTAINER_ID=$(docker ps -a | grep $1 | awk '{ print $1; }')

  if [ ! -z "$CONTAINER_ID" ]; then
    docker stop $CONTAINER_ID
  fi
}

function start_nexus {
  # If there is no nexus container running
  if [ ! $( docker ps | grep nexus | wc -l ) -gt 0 ]; then 
    # If there isn't a stopped container
    if [ ! $( docker ps -a | grep nexus | wc -l ) -gt 0 ]; then
      # Create a new Nexus container
      docker run -p 9000:8081 -h nexus --name nexus -d nexus
    else
      # Start the existing container
      docker start nexus
    fi
  fi  
}

function start_sonar {
  # If there is no Sonar container running
  if [ ! $( docker ps | grep sonar | wc -l ) -gt 0 ]; then 
    # If there isn't a stopped container
    if [ ! $( docker ps -a | grep sonar | wc -l ) -gt 0 ]; then
      # Create a new Sonar Container
      docker run -p 9900:9000 -h sonar --name sonar -d sonar
    else
      # Start the existing container
      docker start sonar
    fi
  fi
}

function start_jenkins_ci {
  if [ ! $( docker ps | grep nexus | wc -l ) -gt 0 ]; then 
    echo "Start a Nexus container first".
    exit 1
  fi

  if [ ! $( docker ps | grep sonar | wc -l ) -gt 0 ]; then 
    echo "Start a Sonar container first".
    exit 1
  fi

  # If there is no Jenkins CI container running
  if [ ! $( docker ps | grep jenkins-ci | wc -l ) -gt 0 ]; then 
    # If there isn't a stopped container
    if [ ! $( docker ps -a | grep jenkins-ci | wc -l ) -gt 0 ]; then
      # Create a new Jenkins CI Container
      docker run -p 8000:8080 -h jenkins-ci --name jenkins-ci --link nexus:nexus --link sonar:sonar \
        -e "DOCKER_API=$(echo $DOCKER_HOST | sed 's/tcp/http/g')"  \
        -d jenkins-ci
    else
      # Start the existing container
      docker start jenkins-ci
    fi
  fi  
}

case "$1" in
remove)
  case "$2" in
    eap-apps)
      echo "Removing EAP Container(s)"
      remove_container "eap"
      ;;
    nexus)
      echo "Removing Nexus Container"
      remove_container "nexus"
      ;;
    jenkins-ci)
      echo "Removing Jenkins CI Container"
      remove_container "jenkins-ci"
      ;;
    sonar)
      echo "Removing Sonar Container"
      remove_container "sonar"
      ;;
    all)
      remove_container "jenkins-ci"
      remove_container "nexus"
      remove_container "sonar"
      remove_container "eap"
      ;;
    *)
      echo "usage: ${NAME} remove-container (eap-apps|nexus|sonar|jenkins-ci)"
      exit 1
    esac
    ;;
remove-image)
  case "$2" in
    eap)
      echo "Removing EAP Image"
      remove_image "eap"
      ;;
    eap-apps)
      echo "Removing EAP App Image"
      remove_image "eap-ticket-monster"
      ;;
    nexus)
      echo "Removing Nexus Image(s)"
      remove_image "nexus"
      ;;
    jenkins)
      echo "Removing Jenkins Base Image(s)"
      remove_image "jenkins"
      ;;
    jenkins-ci)
      echo "Removing Jenkins CI Image(s)"
      remove_image "jenkins-ci"
      ;;
    sonar)
      echo "Removing Sonar Image(s)"
      remove_image "sonar"
      ;;
    all)
      echo "Removing All Images"
      remove_image "eap-ticket-monster"
      remove_image "eap"
      remove_image "nexus"
      remove_image "jenkins"
      remove_image "jenkins-ci"
      remove_image "sonar"
      ;;
    *)
      echo "usage: ${NAME} remove-image (eap-apps|eap|nexus|sonar|jenkins|jenkins-ci|all)"
      exit 1
    esac
    ;;
start)
  case "$2" in
    nexus)
      echo "Starting Nexus container"
      start_nexus
      ;;
    sonar)
      echo "Starting Sonar container"
      start_sonar
      ;;
    jenkins-ci)
      echo "Starting Jenkins CI container"
      start_jenkins_ci
      ;;
    all)
      echo "Starting all containers"
      start_nexus
      start_sonar
      start_jenkins_ci
      ;;
    *)
      echo "usage: ${NAME} start (nexus|sonar|jenkins-ci|all)"
      exit 1
    esac
  ;;
build)
  case "$2" in
    eap)
      echo "Building EAP Base Image"
      build_image "eap"
      ;;
    jenkins)
      echo "Building Jenkins Base Image"
      build_image "jenkins"
      ;;
    nexus)
      echo "Building Nexus Image"
      build_image "nexus"
      ;;
    jenkins-ci)
      echo "Building Jenkins CI Image"
      build_image "jenkins-ci"
      ;;
    sonar)
      echo "Building Sonar Image"
      build_image "sonar"
      ;;
    all)
      echo "Building All Images"
      build_image "eap"
      build_image "jenkins"
      build_image "nexus"
      build_image "jenkins-ci"
      build_image "sonar"
      ;;
    *)
      echo "usage: ${NAME} build (eap|nexus|sonar|jenkins|jenkins-ci|all)"
      exit 1
    esac
    ;;
stop)
  case "$2" in
    jenkins-ci)
      stop_container "jenkins-ci"
      ;;
    nexus)
      stop_container "nexus"
      ;;
    eap-apps)
      stop_container "eap"
      ;;
    sonar)
      stop_container "sonar"
      ;;
    all)
      stop_container "eap"
      stop_container "jenkins-ci"
      stop_container "nexus"
      stop_container "sonar"
      ;;
    *)
      echo "usage: ${NAME} stop (eap-apps|nexus|jenkins-ci|sonar|all)"
      exit 1
    esac
    ;;
*)
    echo "usage: ${NAME} (remove-image|remote|start|stop|build|status)"
    exit 1
esac

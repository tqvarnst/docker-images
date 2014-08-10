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
  pushd ./${IMAGE} >/dev/null
  docker build -q --rm -t ${IMAGE} .
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
  docker rm $CONTAINER_ID
}

function stop_container {
  CONTAINER_ID=$(docker ps -a | grep $1 | awk '{ print $1; }')
  docker stop $CONTAINER_ID
}

case "$1" in
remove-container)
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
    all)
      remove_container "jenkins-ci"
      remove_container "nexus"
      remove_container "eap"
      ;;
    *)
      echo "usage: ${NAME} remove-container (eap-apps|nexus|jenkins-ci)"
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
    all)
      echo "Removing All Images"
      remove_image "eap-ticket-monster"
      remove_image "eap"
      remove_image "nexus"
      remove_image "jenkins"
      remove_image "jenkins-ci"
      ;;
    *)
      echo "usage: ${NAME} remove-image (eap-apps|eap|nexus|jenkins|jenkins-ci|all)"
      exit 1
    esac
    ;;
start)
  # If there is no nexus image running
  if [ ! $( docker ps | grep nexus | wc -l ) -gt 0 ]; then 
    # If there isn't a stopped image
    if [ ! $( docker ps -a | grep nexus | wc -l ) -gt 0 ]; then
      # Create a new Nexus container
      docker run -p 9000:8081 -h nexus --name nexus -d nexus
    else
      # Start the existing container
      docker start nexus
    fi
  fi

  # If there is no Jenkins CI image running
  if [ ! $( docker ps | grep jenkins-ci | wc -l ) -gt 0 ]; then 
    # If there isn't a stopped image
    if [ ! $( docker ps -a | grep jenkins-ci | wc -l ) -gt 0 ]; then
      # Create a new Jenkins CI Container
      docker run -p 8000:8080 -h jenkins-ci --name jenkins-ci --link nexus:nexus \
      	-e "DOCKER_API=$(echo $DOCKER_HOST | sed 's/http/tcp/g')"  \
      	-d jenkins-ci
    else
      # Start the existing container
      docker start jenkins-ci
    fi
  fi
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
    all)
      echo "Building All Images"
      build_image "eap"
      build_image "jenkins"
      build_image "nexus"
      build_image "jenkins-ci"
      ;;
    *)
      echo "usage: ${NAME} build (eap|nexus|jenkins|jenkins-ci|all)"
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
    all)
      stop_container "eap"
      stop_container "jenkins-ci"
      stop_container "nexus"
      ;;
    *)
      echo "usage: ${NAME} stop (eap-apps|nexus|jenkins-ci|all)"
      exit 1
    esac
    ;;
status)
    docker ps
    ;;
help)
    echo "usage: ${NAME} (remove|start|build|status)"
    ;;
*)
    echo "usage: ${NAME} (remove|start|build|status)"
    exit 1
esac

#!/bin/bash
# Update and install Docker
apt-get update -y
apt-get install -y docker.io
 
# Enable and start Docker service
systemctl enable docker
systemctl start docker


docker run -it -p 8080:80 \
  -e OPENPROJECT_SECRET_KEY_BASE=secret \
  -e OPENPROJECT_HOST__NAME=0.0.0.0:8080 \
  -e OPENPROJECT_HTTPS=false \
  -e OPENPROJECT_DEFAULT__LANGUAGE=en \
  openproject/openproject:15

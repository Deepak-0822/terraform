#!/bin/bash
# Update and install Docker
apt-get update -y
apt-get install -y docker.io
 
# Enable and start Docker service
systemctl enable docker
systemctl start docker
 
# Pull the OpenProject Docker image
docker pull openproject/community:latest
 
# Run OpenProject container (port 8080)
docker run -d \
  --name openproject \
  -p 8080:80 \
  openproject/community:latest
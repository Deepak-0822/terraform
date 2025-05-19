#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
docker run -dit --name focalboard -p 8000:8000  mattermost/focalboard
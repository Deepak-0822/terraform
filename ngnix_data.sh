#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
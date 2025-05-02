#!/bin/bash
apt-get update
apt-get install -y nginx

systemctl start nginx
systemctl enable nginx

sudo mkdir -p /usr/share/nginx/html/images
echo "<h1>Images served from Instance B</h1><img src='data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=' alt='dummy'>" > /usr/share/nginx/html/images/index.html

sudo tee /etc/nginx/sites-available/images.conf
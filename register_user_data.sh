#!/bin/bash
apt-get update
apt-get install -y nginx
 
systemctl start nginx
systemctl enable nginx
 
# Create content directory
mkdir -p /usr/share/nginx/html/register
echo "<h1>register served from Instance B</h1><img src='data:register/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=' alt='dummy'>" > /usr/share/nginx/html/register/index.html
 
# Configure Nginx server block
cat <<EOF > /etc/nginx/sites-available/register
server {
    listen 80;
    server_name localhost;
 
    location /register/ {
        alias /usr/share/nginx/html/register/;
        index index.html;
    }
}
EOF
 
# Enable config and disable default
ln -s /etc/nginx/sites-available/register /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
 
# Restart nginx
systemctl restart nginx
#!/bin/bash
# Update and install NGINX
apt update -y
apt install nginx -y
 
# Create custom directory for /register path
mkdir -p /var/www/html/register
 
# Create a simple HTML "Hello from NGINX" page
cat <<EOF > /var/www/html/register/index.html
<!DOCTYPE html>
<html>
<head><title>Hello</title></head>
<body>
<h1>Hello from NGINX /register path!</h1>
</body>
</html>
EOF
 
# Restart nginx to apply changes
systemctl restart nginx
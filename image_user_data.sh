#!/bin/bash
# Update and install NGINX
apt update -y
apt install nginx -y
 
# Create custom directory for /image path
mkdir -p /var/www/html/image
 
# Create a simple HTML "Hello from NGINX" page
cat <<EOF > /var/www/html/image/index.html
<!DOCTYPE html>
<html>
<head><title>Hello</title></head>
<body>
<h1>Hello from NGINX /image path!</h1>
</body>
</html>
EOF
 
# Restart nginx to apply changes
systemctl restart nginx
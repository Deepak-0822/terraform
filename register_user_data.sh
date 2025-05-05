#!/bin/bash
# Update and install nginx
apt update -y
apt install nginx -y
 
# Create custom directory for /register path
mkdir -p /var/www/html/register
 
# Add a simple HTML page for /register
cat <<EOF > /var/www/html/register/index.html
<!DOCTYPE html>
<html>
<head><title>Register</title></head>
<body>
<h1>Hello from /register!</h1>
</body>
</html>
EOF
 
# Restart nginx
systemctl restart nginx
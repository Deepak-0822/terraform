#!/bin/bash
# Update packages and install Apache
yum update -y
yum install -y httpd
 
# Start Apache and enable it to start on boot
systemctl start httpd
systemctl enable httpd
 
# Create a simple homepage
echo "<h1>Welcome to your Apache Server!</h1>" > /var/www/html/index.html
 
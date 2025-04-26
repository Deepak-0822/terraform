#!/bin/bash
# Update packages
apt-get update -y
 
# Install Apache
apt-get install -y apache2
 
# Start Apache and enable it at boot
systemctl start apache2
systemctl enable apache2
 
# Create a simple homepage
echo "<h1>Welcome to your Apache Server!</h1>" > /var/www/html/index.html
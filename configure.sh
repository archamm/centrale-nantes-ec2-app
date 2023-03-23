#!/bin/bash

# Update the package list
sudo yum update -y

# Install Node.js
sudo yum install -y nodejs

# Install Apache (httpd)
sudo yum install -y httpd

# Install Git
sudo yum install git -y

# Install dependencies
npm install

# Build your React app
npm run build

# Configure Apache to serve the React app
sudo bash -c "cat > /etc/httpd/conf.d/react-app.conf << EOL
<VirtualHost *:80>
    DocumentRoot /home/ec2-user/centrale-nantes-ec2-app/build
    ServerName ec2-15-236-206-59.eu-west-3.compute.amazonaws.com

    <Directory /home/ec2-user/centrale-nantes-ec2-app/build>
        AllowOverride None
        Require all granted
        Options -Indexes

        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>

    ErrorLog /var/log/httpd/react-app_error.log
    CustomLog /var/log/httpd/react-app_access.log combined
</VirtualHost>
EOL"

# Start Apache if it's not running
sudo systemctl start httpd

# Restart Apache if it's already running
sudo systemctl restart httpd

# Enable Apache to start at boot
sudo systemctl enable httpd

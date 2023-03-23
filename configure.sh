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
# Define a virtual host listening on port 80
<VirtualHost *:80>
    # Set the document root to the build output directory of your React app
    DocumentRoot /home/ec2-user/centrale-nantes-ec2-app/build
    # Set the server name to the public DNS of your EC2 instance
    ServerName ec2-15-236-206-59.eu-west-3.compute.amazonaws.com

    # Configure the directory containing your React app
    <Directory /home/ec2-user/centrale-nantes-ec2-app/build>
        # Allow access to this directory
        AllowOverride None
        Require all granted
        # Disable directory listing
        Options -Indexes

        # Enable URL rewriting
        RewriteEngine On
        # Set the base URL for rewriting
        RewriteBase /
        # Rewrite requests to index.html if the requested file doesn't exist
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>

    # Set the error log file path
    ErrorLog /var/log/httpd/react-app_error.log
    # Set the access log file path and log format
    CustomLog /var/log/httpd/react-app_access.log combined
</VirtualHost>
EOL"

# Start Apache if it's not running
sudo systemctl start httpd

# Restart Apache if it's already running
sudo systemctl restart httpd

# Enable Apache to start at boot
sudo systemctl enable httpd

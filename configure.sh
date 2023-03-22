#!/bin/bash

# Update the package list
sudo yum update -y

# Install Node.js
sudo yum install -y nodejs

# Install Nginx
sudo yum install -y nginx

# Install Git
sudo yum install git -y

# Install dependencies
npm install

# Build your React app
npm run build

# Remove the default Nginx configuration
sudo rm -f /etc/nginx/conf.d/default.conf

# Create a new configuration file
sudo bash -c "cat > /etc/nginx/conf.d/react-app.conf << EOL
server {
    listen 80;
    server_name ec2-15-236-206-59.eu-west-3.compute.amazonaws.com;

    location / {
        root /home/ec2-user/centrale-nantes-ec2-app/build;
        try_files $uri $uri/ /index.html;
    }
}
EOL"

# Configure Nginx to serve the React app
if ! grep -q "server_names_hash_bucket_size" /etc/nginx/nginx.conf; then
  sudo sed -i '/http {/a \    server_names_hash_bucket_size 128;' /etc/nginx/nginx.conf
fi

# Start Nginx if it's not running
sudo systemctl start nginx

# Restart Nginx if it's already running
sudo systemctl restart nginx

# Enable Nginx to start at boot
sudo systemctl enable nginx
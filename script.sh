#!/bin/bash
# Guides:
# https://hub.docker.com/hardened-images/catalog/dhi/httpd/guides
# https://hub.docker.com/_/httpd
# https://httpd.apache.org/docs/2.4/ssl/ssl_faq.html
#-----------------------------------------------------------------

# Define ServerName and ServerAdmin for httpd-ssl.conf
SERVERNAME="www.example.com"
SERVERADMIN="you@example.com"

# Define your Docker ID and Token as variables
DHI_USER="your-docker-username"
DHI_TOKEN="your-personal-access-token"
DHI_IMAGE="dhi.io/httpd:2.4.68-debian13-dev" # Replace with your required image and tag

# Authenticate to the DHI registry
echo "$DHI_TOKEN" | docker login dhi.io -u "$DHI_USER" --password-stdin

# Pull the image
docker pull "$DHI_IMAGE"

# Get files from the image
docker create --name my_container "$DHI_IMAGE"
docker cp my_container:/usr/local/apache2/conf/httpd.conf .
docker cp my_container:/usr/local/apache2/conf/extra/httpd-ssl.conf .
docker rm temp_container
docker rmi "$DHI_IMAGE"


# Modify the httpd.conf and httpd-ssl.conf to use SSL/HTTPS
sed -i \
    -e "s/^#\(Include .*httpd-ssl.conf\)/\1/" \
    -e "s/^#\(LoadModule .*mod_ssl.so\)/\1/" \
    -e "s/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/" \
    -e "s/^#ServerName www.example.com:80/ServerName ${SERVERNAME}/" \
    httpd.conf

sed -i \
    -e "s/^ServerName www.example.com:443/ServerName ${SERVERNAME}:443/" \
    -e "s/^ServerAdmin you@example.com/ServerAdmin ${SERVERADMIN}/" \
    httpd-ssl.conf


# Create mount directory on the host system
mkdir -p /home/app/apache2/htdocs
sudo chown -R 65532:65532 /home/app/apache2/

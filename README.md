## Apache server using Docker Hardened Image (DHI)

This repository is used to create an Apache web server based on Apache [Docker Hardened Image (DHI)](https://hub.docker.com/hardened-images/catalog/dhi/httpd)  
Files provided:  
- scripts.sh:
  - Pull httpd.conf and httpd-ssl.conf from the container.
  - You need to modify variables inside the script.sh to approreate modify the httpd.conf and httpd-ssl.conf
  - Create mount directory on the host system
- Dockerfile:
  - Used to create your own local image. Modify it if neccessary.
- docker-compose.yml:
  - Used to create the container. Modify it if neccessary.

<br/>

### Pre-configuration:
- Run the script.sh:  
`$ sh script.sh`

- Create SSL Certificate: see [httpd.apache.org](https://httpd.apache.org/docs/2.4/ssl/ssl_faq.html) more mode details
  - Create a self-signed SSL Certificate for testing purposes:  
    `$ openssl genrsa -des3 -out server.key.secure 2048`  
    `$ openssl rsa -noout -text -in server.key.secure`  
    `$ openssl rsa -in server.key.secure -out server.key`   (decrypted, used for auto start web withour password)  
    `$ openssl req -new -x509 -nodes -sha1 -days 365 -key server.key -out server.crt -extensions usr_cert`  
    `$ openssl x509 -noout -text -in server.crt`  

  - Create a real SSL Certificate:  
    See [httpd.apache.org](https://httpd.apache.org/docs/2.4/ssl/ssl_faq.html)
    at the _How do I create a real SSL Certificate?_ section.

<br/>

### Build the image:
`$ docker build -t dhi.io/httpd:2.4.68-debian13 . `

### Start httpd image:
```
$ docker compose up -d
```  
or  
```
$ docker run -d --name my-httpd -p 8080:8080  -p 443:443 \  
  -v /home/app/apache2/htdocs:/usr/local/apache2/htdocs \
  dhi.io/httpd:2.4.68-debian13
```

NOTE:
  - This setting use both 8080 and 433 ports for testing. Port 443 is recommended.
  - Check if it works.
    Go to a web browser and enter _http://localhost:8080_ or _https://localhost:443_


### Some other commands:  
```
$ docker logs <container_id_or_name>      – View httpd log
  docker logs my-httpd
$ docker exec -it <containerID> bash      – Go to container shell, for dhi.io/httpd:2.4.68-debian13-dev only
$ docker cp <containerID>:/container/path/file /host/path/file  – Copy file from container to host system
```
      
<br/><br/>

### Basic docker commands:
```
$ docker pull <image_name>       – Pulls an image from dockerhub
$ docker image ls                – Lists all locally stored Docker images on your host system
$ docker run -d <image_name>     – Creates & starts a new Docker container from animage and runs it in the background
  docker run -it -d --name image_name <image_name>
$ docker ps                      – Lists all currently running Docker container IDs on your system
$ docker ps -a                   – lists all Docker container IDs on your system, regardless of their current status. 
$ docker stop <containerID>      – Gracefully shuts down a running Docker container
$ docker start <containerID>     – Resumes and boots up stopped Docker container
$ docker rm <containerID>        – Remove Docker container

$ docker exec -it <containerID> bash – Opens an interactive command-line terminal (Bash) inside a Docker
                                       container that is already running.
```

<br/>

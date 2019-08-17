# Gateway-In-a-Box (GIB)
Gateway-In-a-Box: A Portable Solution for Developing Science Gateways that Support Interactive and Batch Computing Modes. 

GIB is a reusable and a portable framework for building web portals that support computation and analyses on remote computing resources from the convenience of the web-browser. It is mainly written in Java/Java EE. It provides support for an interactive terminal emulator, batch job submission, file management, storage-quota management, message board, user account management, and also provides an admin console. GIB can be easily deployed on the resources in the cloud or on-premises.

-----------------

## Instructions

* **Installing the front-end and middle layer**

```bash
# Download the git repository
git clone https://github.com/ritua2/gib

# Create the necessary volumes
docker volume create --name=myvol
docker volume create --name=greyfish

# Modify the environment variables for the middle layer
cd gib
vi middle-layer/.env

# Copy the environment variables file to springIPT directory
cp middle-layer/.env springipt/envar.txt

# Start the middle layer and springIPT
cd middle-layer
docker-compose up -d
cd ../springipt

vi .env
(add the following to the .env file)
  MYSQL_ROOT_PASSWORD=Root_Password
  MYSQL_USER=Create_User_Name
  MYSQL_PASSWORD=Your_password
  MYSQL_SERVER=IP_ADDRESS
  
mvn clean package
(if rebuilding: docker kill tomcat_springipt; docker rm tomcat_springipt)
docker-compose up -d --build
```



* **Installing the wetty terminal**


1. Build the wetty and ssh server images
```bash
cd ../new-wetty

# ssh server
docker build -f Dockerfile.ssh -t easy_wetty/ssh:latest .
# Wetty image
docker build -f Dockerfile.wetty -t easy_wetty/standalone:latest .
```


2. Start the ssh server for a temporary volume for local storage

```bash
# Create shared volume for rsync
docker volume create --name=rsync_data

# Start image
docker run -d -e conductor="example.com" -e orchestra_key="orchestra" -p 4646:22 -v rsync_data:/home/rsync_user/data easy_wetty/ssh
```



3. Wetty startup

Requires the ssh server to be setup beforehand


```bash
docker run -d -e conductor="example.com" -e orchestra_key="orchestra" -p 7005:3000 -p 7105:3100 -v rsync_data:/gib/global/data easy_wetty/standalone main_daemon
```







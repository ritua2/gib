# Gateway-In-a-Box (GIB)
Gateway-In-a-Box: A Portable Solution for Developing Science Gateways that Support Interactive and Batch Computing Modes. 

GIB is a reusable and a portable framework for building web portals that support computation and analyses on remote computing resources from the convenience of the web-browser. It is mainly written in Java/Java EE. It provides support for an interactive terminal emulator, batch job submission, file management, storage-quota management, message board, user account management, and also provides an admin console. GIB can be easily deployed on the resources in the cloud or on-premises.

-----------------

## Instructions

* **Installing the front-end and middle layer**

The process may take up to six minutes, particularly the tomcat_springipt container.

The middle-layer contains:
1. Manager node:
2. Greyfish, cloud storage. More information about greyfish can be obtained on its README, both for [this project](https://github.com/ritua2/gib/tree/master/middle-layer/greyfish_storage) or in its [original repository](https://github.com/noderod/greyfish).


```bash
# Download the git repository
git clone https://github.com/ritua2/gib

# Create the necessary volumes
docker volume create --name=myvol
docker volume create --name=greyfish

# Modify the environment variables for the middle layer
# The variale values  are used for setting up the credentails and using them later
cd gib/middle-layer

vi .env
# add the following to the .env file, similar as those in springipt/docker-compose.yml
MYSQL_ROOT_PASSWORD=Root_Password
MYSQL_USER=Create_User_Name
MYSQL_PASSWORD=Your_password
MYSQL_SERVER=IP_ADDRESS

# Copy the environment variables file to springIPT directory
cp .env ../springipt/envar.txt
cp .env ../springipt/.env

# Modify the springIPT variables to be the same as above, including the VM IP
vi ../springipt/src/main/resources/application.properties
  

# Start the middle layer
cd middle-layer
docker-compose up -d

# Enter manager node container
docker exec -it manager_node bash

# If first time, generate an ssh key to allow rsync
ssh-keygen -t rsa -N ""  -f rsync_wetty.key

# Activate (change the number of threads if needed with the -w flag, defined in .env)
gunicorn -w $gthreads -b 0.0.0.0:5000 traffic:app &

# Leave container
exit

# Enter greyfish (storage) container
docker exec -it greyfish bash
cd /grey
# Activate the APIs (change the number of threads if needed, standard is 4)
./API_Daemon.sh -up

# Leave container
exit


# Start springIPT and MySQL containers
cd ../springipt
mvn clean package
# if rebuilding: docker kill tomcat_springipt; docker rm tomcat_springipt
docker-compose up -d --build
```



* **Installing the wetty terminal**

Notes:

This should be done on a different VM than the one on which the middle-layer and front-end are installed.

*conductor* refers to the IP or URL (without http://, https://, or the ending /) where springIPT is located at.

*orchestra_key* refers to the manager's node key, declared in gib/middle-layer/.env


1. Build the wetty and ssh server images
```bash
git clone https://github.com/ritua2/gib

cd gib/new-wetty

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

4. Run the commands below to start 6 instances of the Wetty container on the VM (each VM will support 6 Wetty instances - additional Wetty instances for this project could be provisioned on new VMs - Docker Swarm cluster)

```
docker run -d -e conductor="IP_ADDRESS_OF_SPRINGIPT" -e orchestra_key="9r0gefnipw8eujf9438huycdh7" -p 7000:3000 -p 7100:3100 -v rsync_data:/gib/global/data --name w0 easy_wetty/standalone main_daemon
docker run -d -e conductor="IP_ADDRESS_OF_SPRINGIPT" -e orchestra_key="9r0gefnipw8eujf9438huycdh7" -p 7001:3000 -p 7101:3100 -v rsync_data:/gib/global/data --name w1 easy_wetty/standalone main_daemon
docker run -d -e conductor="IP_ADDRESS_OF_SPRINGIPT" -e orchestra_key="9r0gefnipw8eujf9438huycdh7" -p 7002:3000 -p 7102:3100 -v rsync_data:/gib/global/data --name w2 easy_wetty/standalone main_daemon
docker run -d -e conductor="IP_ADDRESS_OF_SPRINGIPT" -e orchestra_key="9r0gefnipw8eujf9438huycdh7" -p 7003:3000 -p 7103:3100 -v rsync_data:/gib/global/data --name w3 easy_wetty/standalone main_daemon
docker run -d -e conductor="IP_ADDRESS_OF_SPRINGIPT" -e orchestra_key="9r0gefnipw8eujf9438huycdh7" -p 7004:3000 -p 7104:3100 -v rsync_data:/gib/global/data --name w4 easy_wetty/standalone main_daemon
docker run -d -e conductor="IP_ADDRESS_OF_SPRINGIPT" -e orchestra_key="9r0gefnipw8eujf9438huycdh7" -p 7005:3000 -p 7105:3100 -v rsync_data:/gib/global/data --name w5 easy_wetty/standalone main_daemon
```








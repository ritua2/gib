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
docker-compose up -d
```











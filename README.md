# GIB
Gateway-In-a-Box (GIB): A Portable Solution for Developing Science Gateways that Support Interactive and Batch Computing Modes 

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
vi middle-layer/.env

# Copy the environment variables file to springIPT directory
cp middle-layer/.env springipt/envar.txt

# Start the middle layer and springIPT
cd middle-layer
docker-compose up -d
cd ../springipt
docker-compose up -d
```











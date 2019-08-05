### Simplified Wetty terminal


Actual production images will be called via container orchestration.

Build the wetty and ssh server images
```bash
# ssh server
docker build -f Dockerfile.ssh -t easy_wetty/ssh:latest .
# Wetty image
docker build -f Dockerfile.wetty -t easy_wetty/standalone:latest .
```


* **ssh startup**

```bash
# Create shared volume for rsync
docker volume create --name=rsync_data

# Start image
docker run -d -e conductor="example.com" -e orchestra_key="orchestra" -p 4646:22 -v rsync_data:/home/rsync_user/data easy_wetty/ssh
```



* **Wetty startup**

Requires the ssh server to be setup beforehand

Modify *main_daemon.sh* with the necessary conductor IP and orchestra key.

```bash
conductor="example.com" orchestra_key="orchestra" docker-compose up -d
```

Or, if using multiple containers:

```bash
docker run -d -e conductor="example.com" -e orchestra_key="orchestra" -p 7005:3000 -p 7105:3100 -v rsync_data:/gib/global/data easy_wetty/standalone main_daemon
```


#### Wetty miniature server

Each wetty instance includes a built-in miniature server that supports the following functions:
1. 


To call the miniature server:

```bash
#wetty IP and port
export wetty_ip=wetty.example.com:7102

# Wetty 10 character-long key
export wetty_32=abcdefg123

# Get list of all user files currently in wetty
curl http://$wetty_ip/$wetty_32/list_user_files

# Upload a new file (test1.txt)
curl -X POST -F filename=@test1.txt http://$wetty_ip/$wetty_32/upload
# Upload a compressed directory, will be uncompressed and put in /home/gib
curl -X POST -F dirname=@test.tar.gz http://$wetty_ip/$wetty_32/upload_dir

# Download file /home/gib/example/example1.c
curl -X POST -d filepath="/home/gib/example/example1.c" http://$wetty_ip/$wetty_32/download

# Set the container as waiting
curl -X POST -d key="$wetty_32" http://$wetty_ip/wait

# Purge user data from /home/gib
curl -X POST -d key="$wetty_32" -d gk=greyfish -d username=user1 -d greyfish_url=greyfish.example.com http://$wetty_ip/user/purge

# Starts/stops synchronization between the user directory and the shared wetty volume
curl -X POST -d key="$wetty_32" -d action=start -d username=user1 http://$wetty_ip/user/volume/sync
curl -X POST -d key="$wetty_32" -d action=stop -d username=user1 http://$wetty_ip/user/volume/sync
```



#### License

This wetty image contains a miniature http server, that relies on the [cpp-httplib](https://github.com/yhirose/cpp-httplib) header only library developed by 
[yhirose](https://github.com/yhirose), released under the MIT license. A copy of the MIT license for this project is provided [here](https://raw.githubusercontent.com/yhirose/cpp-httplib/master/LICENSE).


The miniature server uploads files to an associated greyfish container using *curl/curl.h*, provided by the libCURL library. A copy of the libCURL license is available [here](./curl_LICENSE.txt) and also in their [main page](https://curl.haxx.se/docs/copyright.html).


### Simplified Wetty terminal

**Note**  
This image is not to be used in production, only for testing the production wetty terminals.  

Actual production images will be called via container orchestration.

Build the image
```bash
docker build -t easy_wetty/standalone:latest .
```


Modify *main_daemon.sh* with the necessary conductor IP and orchestra key.

```bash
conductor="example.com" orchestra_key="orchestra" docker-compose up -d
```

Or, if using multiple containers:

```bash
docker run -d -e conductor="example.com" -e orchestra_key="orchestra" -p 7005:3000 -p 7105:3100  easy_wetty/standalone main_daemon
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

# Download file /home/gib/example/example1.c
curl -X POST -d filepath="/home/gib/example/example1.c" http://$wetty_ip/$wetty_32/download

# Set the container as waiting
curl -X POST -d key="$wetty_32" http://$wetty_ip/wait
```



#### License

This wetty image contains a miniature http server, that relies on the [cpp-httplib](https://github.com/yhirose/cpp-httplib) header only library developed by 
[yhirose](https://github.com/yhirose), released under the MIT license.

A copy of the MIT license for this project is provided [here](https://raw.githubusercontent.com/yhirose/cpp-httplib/master/LICENSE).


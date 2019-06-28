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


#### License

This wetty image contains a miniature http server, that relies on the [cpp-httplib](https://github.com/yhirose/cpp-httplib) header only library developed by 
[yhirose](https://github.com/yhirose), released under the MIT license.

A copy of the MIT license for this project is provided [here](https://raw.githubusercontent.com/yhirose/cpp-httplib/master/LICENSE).


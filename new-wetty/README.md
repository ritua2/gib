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
docker run -d -e conductor="example.com" -e orchestra_key="orchestra" -p 7005:3000  easy_wetty/standalone main_daemon
```

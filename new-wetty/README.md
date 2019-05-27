### Simplified Wetty terminal

**Note**  
This image is not to be used in production, only for testing the production wetty terminals.  

Actual production images will be called via container orchestration.


Modify *main_daemon.sh* with the necessary conductor IP and orchestra key.

```bash
conductor="example.com" orchestra_key="orchestra" SLURM="http://slurm.example.com:5600"  docker-compose up -d
```

Or, if using multiple containers:

```bash
docker run -d -e conductor="example.com" -e orchestra_key="orchestra" -e SLURM="http://slurm.example.com:5600" -p 7005:3000  \
		easy_wetty/standalone main_daemon
```




# DELETE THIS

docker run -d -e conductor="149.165.156.208" -e orchestra_key="swisspeakmontblanc" -e SLURM="http://149.165.170.15:5600" -p 7005:3000  \
		easy_wetty/standalone main_daemon

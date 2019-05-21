### Simplified Wetty terminal

**Note**  
This image is not to be used in production, only for testing the production wetty terminals.  

Actual production images will be called via container orchestration.


Modify *main_daemon.sh* with the necessary conductor IP and orchestra key.

```bash
conductor="example.com" orchestra_key="orchestra" SLURM="http://slurm.example.com:5600"  docker-compose up -d
```

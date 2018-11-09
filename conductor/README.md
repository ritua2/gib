### Container orchestration for multiple *gateway-in-a-box* wetty instances


**Installation**  

All setup is autmatic after the repository has been initialized. User simply needs to specify the Redis key,
the base URL for the project, and the base key to be used administrative purposes.  
The InfluxDB database, although installed, is not used for the current iteration of the project. Nonetheless,
it will be used in the future to maintain user access logs.


```bash
	# Change the influxdb log credentials
	vi credentials.yml
	# Select a redis password
	URL_BASE=$SERVER_URL REDIS_AUTH=$REDIS_AUTH orchestra_key=$ORCHESTRA_KEY PROJECT=$PROJECT_NAME  docker-compose up -d --build
```

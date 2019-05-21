### Container orchestration for multiple *gateway-in-a-box* wetty instances


**Installation**  

All setup is autmatic after the repository has been initialized. User simply needs to specify the Redis key,
the base URL for the project, and the base key to be used administrative purposes.



```bash
	# Select a redis password
	URL_BASE=example.com REDIS_AUTH=redispassword orchestra_key=orchestra PROJECT=gib GREYFISH_URL=greyfishexample.com GREYFISH_REDIS_KEY=greyfish  docker-compose up -d --build
```

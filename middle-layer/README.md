### Middle-layer for *gateway-in-a-box*


**Installation**  

All setup is automatic after the repository has been downloaded. Modify the environmental variables in command line or in *.env*.
It is strongly recommended that the user change all the passwords and keys provided.




```bash
	# Select a redis password
	source .env
	docker-compose up -d --build
```

To activate or switch off the APIs, enter the greyfish docker container and do:  

```bash
# Enter container
docker exec -it greyfish bash
cd /grey
# Start the needed databases and assign permission (APIs will not be started)
/grey/setup.sh
# Activate (change the number of threads if needed, standard is 4)
./API_Daemon.sh -up
# Deactivate
./API_Daemon.sh -down
```


**Note**

A previous version of the current code, written in go is available [here](./manager_node/gocode). Both are similar as of May 27th, 2019 but the go version will no longer be maintained.

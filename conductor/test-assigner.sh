#!/bin/bash

# create a new user
curl -X POST -H "Content-Type: application/json" -d '{"key":"ok496", "sender":"carlos"}' http://149.165.156.208:5000/api/assign/users/charlie

# Get the username
# curl http://149.165.156.208:5000/api/instance/whoami
# IP to go
# http://149.165.156.208:5000/api/redirect/users/charlie/129.114.16.120

# Attach the instance
# curl -X POST -H "Content-Type: application/json" -d '{"key":"ok496", "sender":"T1"}' http://149.165.156.208:5000/api/instance/attachme

# Free instance
# curl http://149.165.156.208:5000/api/instance/freeme

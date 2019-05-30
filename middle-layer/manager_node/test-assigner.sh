#!/bin/bash
# create a new user
curl -X POST -H "Content-Type: application/json" -d '{"key":"swisspeakmontblanc", "sender":"carlos"}' http://149.165.156.208:5000/api/assign/users/charlie
# Get the username
# curl http://149.165.156.208:5000/api/instance/whoami/$UUID_f10
# IP to go
# http://149.165.156.208:5000/api/redirect/users/charlie/149.165.157.17
# Attach the instance
# curl -X POST -H "Content-Type: application/json" -d '{"key":"swisspeakmontblanc", "sender":"T1", "port":"7002"}' http://149.165.156.208:5000/api/instance/attachme
# Free instance
# curl http://149.165.156.208:5000/api/instance/freeme/$UUID_f10

# Removes the current port
# curl -X POST -H "Content-Type: application/json" -d '{"key":"swisspeakmontblanc", "sender":"T1", "port":"7002"}' http://149.165.156.208:5000/api/instance/remove_my_port


# Get a list of available containers
# http://149.165.156.208:5000/api/status/containers/available

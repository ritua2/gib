#!/bin/bash


# Creates the databases:
#  | -greyfish:  Contains all greyfish data
#  | -user_data: Only refers to those users and the time of signing up or deleting their accounts
#  | -common:    Generic file/dir uploads and downloads
#  | -deletes:   Deleted file/dir
#  | -overhaul:  Only covers users who have completely updated their repo using the appropriate command


curl -XPOST -u $INFLUXDB_ADMIN_USER:$INFLUXDB_ADMIN_PASSWORD  http://$URL_BASE:8086/query --data-urlencode 'q=CREATE DATABASE "greyfish"'
curl -XPOST -u $INFLUXDB_ADMIN_USER:$INFLUXDB_ADMIN_PASSWORD  http://$URL_BASE:8086/query --data-urlencode 'q=CREATE DATABASE "failed_login"'
printf "Created InfluxDB databases\n"

# Assigns write privileges
curl -XPOST -u $INFLUXDB_ADMIN_USER:$INFLUXDB_ADMIN_PASSWORD  http://$URL_BASE:8086/query \
    --data-urlencode "q=GRANT WRITE ON \"greyfish\" TO \"$INFLUXDB_WRITE_USER\""
curl -XPOST -u $INFLUXDB_ADMIN_USER:$INFLUXDB_ADMIN_PASSWORD  http://$URL_BASE:8086/query \
    --data-urlencode "q=GRANT WRITE ON \"failed_login\" TO \"$INFLUXDB_WRITE_USER\""

# Assigns read privileges
curl -XPOST -u $INFLUXDB_ADMIN_USER:$INFLUXDB_ADMIN_PASSWORD  http://$URL_BASE:8086/query \
    --data-urlencode "q=GRANT READ ON \"greyfish\" TO \"$INFLUXDB_READ_USER\""

# False logins remain an admin priviledge

printf "Database privileges have been added\n"


rm -- "$0"

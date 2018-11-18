#!/bin/bash


# generates a random UUID for the current terminal, a set of 32 random characters
NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

printf "$NEW_UUID" > ./autokey

conductor=
orchestra_key=


# Sets up a listener API to check which port this is
{ echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c <./autokey)\r\n\r\n"; cat ./autokey; } | nc -l 3000 &

# Gets the IP of the current device
machine_ip=$(curl "http://$conductor:5000/api/instance/whatsmyip")


# Listens to available ports in the current machine, to check which one has the current API
current_port="NA"
for port in $(seq 7000 7010);
do
    # Stops when it finds itself
    NK=$(curl --max-time 10 "$machine_ip:$port") || true

    if [ "$NK" = "$NEW_UUID" ]; then
        current_port="$port"
        break
    fi
done

rm ./autokey

# Kill all listener APIs
if [ "$current_port" = "NA" ]; then

    # TODO: Message server about failed instance setup
    printf "Failed wetty setup. Instance could not find itself\n"
    exit
fi


# Calls the server to specify that a new instance is being created
curl -X POST -H "Content-Type: application/json" -d '{"key":"'$orchestra_key'", "sender":"'$NEW_UUID'", "port":"'$current_port'"}' \
    http://$conductor:5000/api/instance/attachme


rm ./autokey

# Kill all listener APIs
pkill nc

monitor_login &
monitor_logout &

yarn start

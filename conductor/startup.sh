#!/bin/bash


# Gets the username
export USER=$(curl http://$MANAGER_NODE:5000/api/instance/whoami/$UUID_f10)



# If the user is not what is expected, it exits
if [ "$USER" = "Empty" ]; then
   printf "Access not allowed\n"
   exit
fi

# Gets the greyfish server location
export GS=$(curl http://$MANAGER_NODE:5000/api/greyfish/location)

# Gets two greyfish keys
GK1=$(curl -s http://$MANAGER_NODE:5000/api/greyfish/new/single_use_token/$UUID_f10)
GK2=$(curl -s http://$MANAGER_NODE:5000/api/greyfish/new/single_use_token/$UUID_f10)


# Gets all the user files
curl http://$GS:2001/grey/get_all/$GK1/$USER > summary.tar.gz

# Checks that the previous data is actually tarred
if { tar ztf "summary.tar.gz" || tar tf "summary.tar.gz"; } >/dev/null 2>&1; then
   tar -xzf summary.tar.gz
   rm -f /home/gib/home/gib/.bash_logout
   mv /home/gib/home/gib/* /home/gib
   rm -rf /home/gib/home
fi

rm -f summary.tar.gz

# Gets the project
export PROJECT=$(curl -s http://$MANAGER_NODE:5000/api/project/name)

# Changes the terminal prompt to [/PROJECT/USERNAME: ~] $ 

PS1="$USER@$PROJECT: $PWD \$ " 

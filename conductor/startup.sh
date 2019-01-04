#!/bin/bash


# Gets the username
export USER=$(curl http://$MANAGER_NODE:5000/api/instance/whoami)


# Gets the greyfish server location


# If the user is not what is expected, it exits
if [ $USER = "Empty" ]; then
   printf "Access not allowed\n"
   exit
fi


# Gets the project
export PROJECT=$(curl http://$MANAGER_NODE:5000/api/project/name)

# Changes the terminal prompt to [/PROJECT/USERNAME: ~] $ 

PS1="$USER@$PROJECT: $PWD \$ " 

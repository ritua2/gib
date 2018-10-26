#!/bin/bash


# Gets the username
export USER=$(curl http://$MANAGER_NODE:5000/api/instance/whoami)


# Gets the project
export PROJECT=$(curl http://$MANAGER_NODE:5000/api/project/name)

# Changes the terminal prompt to [/PROJECT/USERNAME: ~] $ 

PS1="$USER@$PROJECT: $PWD \$ " 

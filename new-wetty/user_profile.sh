#!/bin/bash
source /home/ipt/.bashrc


# Add startup script to recover user data from greyfish
curl -O http://$MAIN_NODE:5000/api/scripts/startup

source startup

rm startup

#!/bin/bash
export MANAGER_NODE="149.165.156.208"


# Add startup script to recover user data from greyfish
curl -O http://$MANAGER_NODE:5000/api/scripts/startup

unset HISTFILE # No history
source startup

rm startup
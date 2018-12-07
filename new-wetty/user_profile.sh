#!/bin/bash



# Only useful for users, not maintenance
if [ $USER = "gib" ]; then

    # Add startup script from the orchestration server

    curl -O http://$MANAGER_NODE:5000/api/scripts/startup

    unset HISTFILE # No history
    source startup

    rm startup

fi

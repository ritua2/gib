# Executes when the user logs out


if [ $USER != "Empty" ]; then
    # Free instance
    curl http://$MANAGER_NODE:5000/api/instance/freeme
    # Deletes all user files that can be deleted
    rm /home/ipt/*
fi

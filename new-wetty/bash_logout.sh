# Executes when the user logs out

# Free instance
curl http://$MANAGER_NODE:5000/api/instance/freeme


# Deletes all user files that can be deleted
rm /home/ipt/*
pkill monitor

#!/bin/bash



# Colors, helpful for printing
GREENGREEN='\033[0;32m'
REDRED='\033[0;31m'
YELLOWYELLOW='\033[1;33m'
BLUEBLUE='\033[1;34m'
NCNC='\033[0m' # No color



# Creates a directory
RNAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
newdir="$USER"_"$RNAME"
mkdir $newdir
jfile="$newdir/meta.json"
printf "{\n" >> $jfile
printf "\"User\":\"$USER\",\n" >>  $jfile


###############
# Commands
###############

printf "${BLUEBLUE}  Enter the list of input commands (must be bash compatible), as you would in a terminal${NCNC}\n"
printf "${BLUEBLUE}  Empty command to finish ${NCNC}\n"

number_of_commands=0

while true
do
    read COM
    COMSAFE="${COM//\"/\\\\\"}" 

    if [ -z "$COM" ]; then
        break
    fi

    printf "\"$number_of_commands\":\"$COMSAFE\",\n" >> $jfile

    number_of_commands=$(($number_of_commands + 1))

done


#######################################
# Necessary files and subdirectories
#######################################

printf "\n\n\n"
printf "${YELLOWYELLOW}  Enter the list of input directories, one per line${NCNC}\n"
printf "${YELLOWYELLOW}  Empty command to finish ${NCNC}\n"


while true
do

    read user_dir

    if [ -z "$user_dir" ]; then
        printf "No more directories have been added\n"
        break
    fi

    if [ ! -d "$user_dir" ]; then
        printf "${REDRED}$user_dir does not exist${NCNC}\n"
        continue
    fi

    cp -r "$user_dir" $newdir

done



printf "\n\n"
printf "${YELLOWYELLOW}  Enter the list of input files, one per line${NCNC}\n"
printf "${YELLOWYELLOW}  Empty command to finish ${NCNC}\n"


while true
do

    read user_fil

    if [ -z "$user_fil" ]; then
        printf "No more files have been added\n"
        break
    fi

    if [ ! -f "$user_fil" ]; then
        printf "${REDRED}$user_fil does not exist${NCNC}\n"
        continue
    fi

    cp -r "$user_fil" $newdir

done




##########################
# Zip and metadata
##########################


# Gets the date in format YYYY-MM-DD hh:mm:ss 
YYYYMMDD="$(date +%F) $(date +%H):$(date +%M):$(date +%S)" 
unix_time=$(date +%s)

# Adds other metadata
printf "\"NC\":\"$number_of_commands\",\n" >> $jfile
printf "\"Unix_time\":\"$unix_time\",\n" >> $jfile
printf "\"Date\":\"$YYYYMMDD\"\n}" >> $jfile


zip -r "$newdir".zip "$newdir"


printf "\n\n"

# Uploads the result
curl -s -F file=@"$newdir".zip $SLURM/gib/upload/job

printf "\n\n"

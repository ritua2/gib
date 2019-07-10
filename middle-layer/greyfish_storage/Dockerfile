##########################
# BASICS
# 
# An alpine server with python3 installed, useful only as a cloud storage server
# Not designed for front-end interfaces
#########################

FROM python:3.6-alpine


# Copies the necessary files
COPY base_functions.py  /grey/base_functions.py
COPY remove_files.py    /grey/remove_files.py
COPY new_user.py        /grey/new_user.py
COPY gget_all.py        /grey/gget_all.py
COPY push_all.py        /grey/push_all.py
COPY grey_regular.py    /grey/grey_regular.py
COPY admin.py           /grey/admin.py
COPY API_Daemon.sh      /grey/API_Daemon.sh
COPY checksums.py       /grey/checksums.py


# Installs the necessary packages
# Bash for convenience
RUN apk update && apk add bash curl openrc openssh && mkdir -p /greyfish/sandbox &&\
    pip3 install gunicorn Flask redis requests &&\
    chmod +x /grey/new_user.py /grey/grey_regular.py /grey/gget_all.py /grey/push_all.py /grey/API_Daemon.sh /grey/admin.py &&\
    # Creates new rsync user and it gives it permission over greyfish files
    addgroup -S greyfish && adduser -S grey_rsync -G greyfish --shell /bin/bash &&\
    chgrp greyfish -R /greyfish && chmod g+w -R /greyfish/ &&\
    # Change the default password if needed
    # However, the main security is enforced via the ssh key
    yes "wetty_greyfish_rsync" | passwd grey_rsync &&\
    # Starts an ssh server, modifying the connection port from the regular 22 to 4646 (arbitrary number)
    printf "\n#Changed ssh port to 4646\nPort 4646\n" >> /etc/ssh/sshd_config &&\
    rc-update add sshd && mkdir -p /home/grey_rsync/.ssh && touch /home/grey_rsync/.ssh/authorized_keys &&\
    mkdir -p /run/openrc && touch /run/openrc/softlevel



WORKDIR /greyfish

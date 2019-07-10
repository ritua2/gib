FROM node:10-jessie



ENV gib_user "gib"
ENV gib_password "gib"

COPY user_profile.sh /user_scripts/.profile
COPY bash_logout.sh  /user_scripts/.bash_logout
COPY introduction.txt /etc/motd
COPY main_daemon.sh    /bin/main_daemon
COPY miniserver.cc     /gib/miniserver.cc
COPY wetty             /gib/wetty
COPY index_client.js   /gib/index_client.js


WORKDIR /gib


RUN apt-get update && apt-get install -y netcat netcat-openbsd tree unzip vim zip &&\
    cd wetty/ && yarn && yarn build && yarn global add wetty.js &&\
    useradd -ms /bin/bash "$gib_user"  && echo "$gib_user":"$gib_password" | chpasswd &&\
    chmod +x /bin/main_daemon &&\
    # Disallows su
    chmod 000 /bin/su &&\
    # Sets up the miniature server for executing commands in terminals with users
    curl https://raw.githubusercontent.com/yhirose/cpp-httplib/master/httplib.h > /gib/httplib.h &&\
    cd /gib && g++ /gib/miniserver.cc -o miniserver -std=c++1y -pthread



CMD main_daemon

FROM node:10-jessie



ENV gib_user "gib"
ENV gib_password "gib"

COPY user_profile.sh /user_scripts/.profile
COPY bash_logout.sh  /user_scripts/.bash_logout
COPY introduction.txt /etc/motd
COPY main_daemon.sh    /bin/main_daemon


WORKDIR /gib


RUN apt-get update && apt-get install -y vim &&\
    git clone https://github.com/krishnasrinivas/wetty.git &&\
    cd wetty/ && yarn && yarn build && yarn global add wetty.js &&\
    useradd -ms /bin/bash "$gib_user"  && echo "$gib_user":"$gib_password" | chpasswd &&\
    chmod +x /bin/main_daemon &&\
    # Disallows su
    chmod 000 /bin/su



CMD main_daemon

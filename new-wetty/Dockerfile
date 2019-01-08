FROM krishnasrinivas/wetty


COPY user_profile.sh /user_scripts/.profile
COPY bash_logout.sh  /user_scripts/.bash_logout
COPY introduction.txt /etc/motd
COPY main_daemon.sh    /bin/main_daemon

USER root

RUN apk add --no-cache bash && adduser -D -h /home/gib -s /bin/bash gib  &&\
    echo "gib:" | chpasswd  &&\
    # Add sudo group
    apk --no-cache  add shadow curl inotify-tools netcat-openbsd  unzip &&  userdel -r term &&\
    # Startup scripts are immutable
    chown -R gib:gib /home/gib &&\
    # Disallows su
    chmod 000 /bin/su &&\
    chmod +x /bin/main_daemon

CMD main_daemon

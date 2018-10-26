FROM krishnasrinivas/wetty

COPY user_bashrc.sh  /user_scripts/.bashrc
COPY user_profile.sh /user_scripts/.profile
COPY bash_logout.sh  /user_scripts/.bash_logout
COPY introduction.txt /etc/motd


RUN apk add --no-cache bash && adduser -D -h /home/ipt -s /bin/bash ipt  &&\
    echo "ipt:" | chpasswd  &&\
    # Add sudo group
    apk --no-cache  add shadow curl inotify-tools  &&  userdel -r term &&\
    # Enters the start command 
    cp  -r /user_scripts/. /home/ipt  &&\
    # Startup scripts are immutable
    chown -R ipt:ipt /home/ipt &&\
    # Disallows su
    chmod 000 /bin/su

CMD yarn start

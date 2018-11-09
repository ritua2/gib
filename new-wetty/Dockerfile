FROM krishnasrinivas/wetty

COPY user_profile.sh /user_scripts/.profile
COPY bash_logout.sh  /user_scripts/.bash_logout
COPY introduction.txt /etc/motd
# Adds the monitoring scripts
COPY monitor_login.sh  /bin/monitor_login
COPY monitor_logout.sh /bin/monitor_logout
COPY main_daemon.sh    /bin/main_daemon


RUN apk add --no-cache bash && adduser -D -h /home/ipt -s /bin/bash ipt  &&\
    echo "ipt:" | chpasswd  &&\
    # Add sudo group
    apk --no-cache  add shadow curl inotify-tools  &&  userdel -r term &&\
    # Enters the start command 
    cp  -r /user_scripts/. /home/ipt  &&\
    # Startup scripts are immutable
    chown -R ipt:ipt /home/ipt &&\
    # Disallows su
    chmod 000 /bin/su &&\
    chmod +x /bin/main_daemon && chmod +x /bin/monitor*

CMD main_daemon

FROM krishnasrinivas/wetty

COPY user_bashrc.sh  /user_scripts/.bashrc
COPY user_profile.sh /user_scripts/.profile
COPY bash_logout.sh  /user_scripts/.bash_logout
COPY introduction.txt /etc/motd

RUN apk add --no-cache bash && adduser -D -h /home/ipt -s /bin/bash ipt  &&\
    echo "ipt:" | chpasswd  &&\
    # Adds sudo group
    apk --no-cache  add shadow sudo curl && addgroup sudo && usermod -a -G sudo ipt && userdel -r term &&\
    # Enters the start command 
    cp -a /user_scripts/. /home/ipt  &&\
    # Users cannot modify startup scripts
    chown -R ipt /home/ipt/ &&\
    chmod u=rx /home/ipt/.bash* /home/ipt/.profile &&\
    # Disallows su
    chmod 000 /bin/su &&\
    # Cleanup
    rm -rf /user_scripts

CMD yarn start


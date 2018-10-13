FROM krishnasrinivas/wetty


COPY user_bashrc.sh  /user_scripts/.bashrc
COPY user_profile.sh /user_scripts/.profile


RUN apk add --no-cache bash && adduser -D -h /home/ipt -s /bin/bash ipt  &&\
    echo "ipt:ipt" | chpasswd  &&\
    # Adds sudo group
    apk --no-cache  add shadow sudo && addgroup sudo && usermod -a -G sudo ipt && userdel -r term &&\
    # Allows sudo access
    printf "\n%%sudo   ALL=(ALL) ALL\n" >> /etc/sudoers &&\
    # Enters the start command 
    cat /user_scripts/.bashrc >> /home/ipt/.bashrc &&\
    cat /user_scripts/.profile  >> /home/ipt/.profile &&\
    # Cleanup
    rm -rf /user_scripts



# Base
CMD yarn start

FROM python:3.7-alpine


COPY traffic.py                 /conductor/traffic.py
COPY startup.sh                 /scripts/startup.sh
COPY connected_users.py         /conductor/connected_users.py 
COPY synchronizer.sh            /conductor/synchronizer.sh




RUN apk add --no-cache bash git openssh-client rsync && pip3 install Flask gunicorn mysql-connector-python redis requests &&\
    chmod +x /conductor/synchronizer.sh


WORKDIR /conductor

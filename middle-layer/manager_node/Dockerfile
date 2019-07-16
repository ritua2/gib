FROM python:3.7-alpine


COPY traffic.py                 /conductor/traffic.py
COPY startup.sh                 /scripts/startup.sh





RUN apk add --no-cache bash git openssh-client rsync && pip3 install Flask gunicorn redis requests


WORKDIR /conductor

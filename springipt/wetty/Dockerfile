FROM node:6

COPY . /app
WORKDIR /app


RUN npm install &&\
    apt-get update && \
    apt-get install -y vim &&\
    groupadd --gid 818565 G-818565 && \
    useradd --create-home --shell /bin/bash term && \
    echo 'term:term' | chpasswd &&\
    chmod -R 777 /root && \
    chown -R term:G-818565 /home/term && \
    chmod -R 777 /app/public &&\
    cd ~ && apt-get install -y zsh &&\
    apt-get clean && apt-get autoclean &&\
    apt-get autoremove -y && rm -rf /var/lib/cache/* &&\
    rm -rf /var/lib/log/*
USER term
RUN chown -R term /home/term && echo "all done"

USER root

EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]

FROM node:6

ADD . /app
WORKDIR /app
RUN npm install
RUN apt-get update
RUN apt-get install -y vim
RUN useradd -d /home/term -m -s /bin/bash term
RUN echo 'term:term' | chpasswd

RUN cd ~
RUN apt-get install -y zsh
RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/cache/*
RUN rm -rf /var/lib/log/*
USER term
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
#RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN cp /app/.zshrc ~/.zshrc
RUN echo "term" | chsh -s /bin/zsh
USER root

EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]

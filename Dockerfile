FROM alpine

MAINTAINER tyurin@m1ke.ru

#ENVIROMENT
ENV	SERVE_DIR=/project \
    GIT=git@10.78.1.202:avtodor/etp.wiki.git \
    GIT_FQDN=10.78.1.202 \
    MKDOCS_VERSION=1.0.4 \
    GIT_REPO='false' \
    LIVE_RELOAD_SUPPORT='true' \
    ADD_MODULES='false'


#INSTALL
RUN apk update && apk upgrade && \
    apk add --no-cache bash git python3 python3-dev 
RUN apk add --no-cache supervisor openssh && \
    mkdir /root/.ssh && chmod 0700 /root/.ssh && \
    chown -R root:root /root/.ssh && \
    pip3 install --upgrade pip && \
    pip install mkdocs==${MKDOCS_VERSION} && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
COPY ssh /root/.ssh/
COPY mkdocs.sh /usr/bin/
RUN  ssh-keyscan -t rsa $GIT_FQDN >> ~/.ssh/known_hosts && \
    cd $SERVER_DIR && git clone $GIT




COPY supervisord.conf /etc/
EXPOSE 9191
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]


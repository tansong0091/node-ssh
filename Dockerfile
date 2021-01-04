FROM node:14.15.2-alpine3.12 

COPY entrypoint.sh /entrypoint.sh
COPY deploy/crt /apps/crt
RUN apk update \
    && apk --update add curl bash ttf-dejavu tzdata openssh \ 
    && rm -rf /var/cache/apk/* \
    && apk add mysql-client \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && chmod +x /entrypoint.sh \
    && chmod 755 -R /apps/crt \
    && cd /apps/crt \
    && npm install \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -P "" \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -P "" \
    && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -P "" \
    && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -P "" \
    && echo 'root:THEPASSWORDYOUCREATED' | chpasswd
 

COPY sshd_config /etc/ssh/sshd_config

EXPOSE 3000 10023
ENTRYPOINT ["/entrypoint.sh"]

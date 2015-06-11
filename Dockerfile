FROM fedora:latest

RUN dnf -y upgrade
RUN dnf -y install supervisor nginx httpd-tools
RUN dnf -y install https://github.com/abn/docker-registry-rpm/releases/download/v2.0.1-1/docker-registry-2.0.1-1.el7.centos.x86_64.rpm 

ENV CONFIG /config
ENV REGISTRY_HOST localhost
ENV REGISTRY_PORT 5000

RUN mkdir -p ${CONFIG}
RUN mkdir -p /etc/nginx/ssl

ADD ./assets/nginx.conf /etc/nginx/conf.d/default.conf
ADD ./assets/supervisord.conf /etc/supervisord.conf
ADD ./assets/entrypoint /usr/bin/entrypoint

EXPOSE 443
VOLUME ["${CONFIG}"]

ENTRYPOINT ["/usr/bin/entrypoint"]

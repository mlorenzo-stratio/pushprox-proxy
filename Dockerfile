FROM golang:alpine AS build

RUN apk update &&  \
    apk upgrade && \
    apk add --no-cache git && \
    go get github.com/stratio/pushprox/proxy && \
    cd /go/src/github.com/stratio/pushprox/proxy && \
    go build

FROM alpine
MAINTAINER Marcos Lorenzo de Santiago <marcos.lorenzodesantiago@gmail.com>
LABEL Description="ProxPush proxy docker image"
COPY --from=build /go/bin/proxy /pushprox-proxy
COPY nginx.conf.template /etc/nginx/
COPY entrypoint.sh /
RUN apk add --no-cache bash gettext nginx && \
    mkdir /etc/nginx/certs && \
    cd /var/log/nginx/ && \
    ln -s /dev/stdout access.log && \
    ln -s /dev/stderr error.log

EXPOSE 7070/tcp 7071/tcp

ENTRYPOINT [ "/entrypoint.sh" ]

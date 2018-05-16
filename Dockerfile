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
COPY entrypoint.sh /

EXPOSE 7070/tcp

ENTRYPOINT [ "/entrypoint.sh" ]

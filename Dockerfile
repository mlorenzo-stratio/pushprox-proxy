FROM golang:alpine AS build

RUN apk update &&  \
    apk upgrade && \
    apk add --no-cache git && \
    go get github.com/robustperception/pushprox/proxy && \
    cd /go/src/github.com/robustperception/pushprox/proxy && \
    go build


FROM alpine
MAINTAINER Marcos Lorenzo de Santiago <marcos.lorenzodesantiago@gmail.com>
LABEL Description="ProxPush proxy docker image"
COPY --from=build /go/bin/proxy /proxy

ENTRYPOINT [ "/proxy" ]

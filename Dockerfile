FROM golang:alpine3.8 as builder

RUN apk --update upgrade \
&& apk --no-cache --no-progress add make git \
&& rm -rf /var/cache/apk/*

WORKDIR /go/src/github.com/mdbraber/acmeproxy
COPY . .
RUN make build

FROM alpine:3.8
RUN apk update && apk add --no-cache --virtual ca-certificates
COPY --from=builder /go/src/github.com/mdbraber/acmeproxy/dist/acmeproxy /usr/bin/acmeproxy
ENTRYPOINT [ "/usr/bin/acmeproxy" ]

# -- Go Builder Image --
FROM golang:1.10-alpine AS builder

ENV DEP_VERSION=0.4.1

RUN apk add --no-cache git curl
RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v${DEP_VERSION}/dep-linux-amd64 && chmod +x /usr/local/bin/dep
COPY . /go/src/drone-chartmuseum
WORKDIR /go/src/drone-chartmuseum

# https://github.com/golang/dep/blob/master/docs/FAQ.md#how-do-i-use-dep-with-docker
RUN set -ex \
    && dep ensure \
    && go build -v -o "/drone-chartmuseum"

# -- drone-chartmuseum Image --
FROM alpine:3.7
RUN set -ex \
    && apk add --no-cache bash ca-certificates git

COPY --from=builder /drone-chartmuseum /bin/drone-chartmuseum
ENTRYPOINT [ "/bin/drone-chartmuseum" ]

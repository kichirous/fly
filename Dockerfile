FROM alpine:edge

RUN apk update && \
    apk add --no-cache --virtual ca-certificates caddy tor wget && \
    rm -rf /var/cache/apk/*

COPY Caddyfile /Caddyfile
COPY config.json /config.json

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh

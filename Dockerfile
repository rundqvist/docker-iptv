FROM rundqvist/supervisor:latest

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

RUN apk --update --no-cache add coreutils xmltv perl-datetime-format-strptime 
RUN apk --update --no-cache add nginx nginx-mod-rtmp ffmpeg
RUN apk update && apk upgrade && apk add --no-cache python3 && \
    apk add --no-cache --virtual .build-deps gcc musl-dev && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip && \
    pip3 install -U streamlink && \
    apk del .build-deps

RUN mkdir /app/telly/ && wget -P /app/telly/ https://github.com/tombowditch/telly/releases/download/v0.4.5/telly-linux-amd64 && \
    mv /app/telly/telly-* /app/telly/telly && \
    chmod +x /app/telly/telly

RUN apk --update add nginx-mod-stream
COPY root /

ENV IPTV_SERVICES='' \
    IPTV_DAYS='2'

EXPOSE 8888

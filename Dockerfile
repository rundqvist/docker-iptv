FROM rundqvist/supervisor:latest

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

#RUN apk --update --no-cache add coreutils xmltv perl-datetime-format-strptime 
RUN apk --update --no-cache add nginx ffmpeg
# RUN apk update && apk upgrade && apk add --no-cache python3 && \
#     apk add --no-cache --virtual .build-deps gcc musl-dev && \
#     python3 -m ensurepip && \
#     pip3 install --upgrade pip && \
#     pip3 install -U streamlink && \
#     apk del .build-deps

COPY root /

ENV IPTV_SERVICES='' \
    IPTV_DAYS='2'

EXPOSE 8888

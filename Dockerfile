FROM rundqvist/supervisor:latest

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

RUN apk --update --no-cache add coreutils nginx xmltv perl-datetime-format-strptime
# xmltv
# perl-datetime-format-strptime - dependency for tv_merge
RUN mkdir -p /cache/iptv/xmltv
ENV HOST_IP='' \
    IPTV_SERVICES='' \
    IPTV_DAYS='2'

EXPOSE 8888

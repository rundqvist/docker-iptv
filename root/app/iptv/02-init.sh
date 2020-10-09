#!/bin/sh

chmod +x /app/iptv/channel.sh

> /app/iptv/supervisord.conf
for service in $(var IPTV_SERVICES)
do
    for channel in $(var -k iptv.channel "$service")
    do
        log -i "Preparing $channel"
        cat /app/iptv/supervisord.template.conf | sed 's/{channel}/'$channel'/g' >> /app/iptv/supervisord.conf
    done
done

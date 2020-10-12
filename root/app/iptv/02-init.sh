#!/bin/sh

chmod +x /app/iptv/channel.sh

> /app/iptv/supervisord.conf
for service in $(var IPTV_SERVICES)
do
    if [ $(echo "$service" | grep ':') ]
    then
        port="$(echo $service | cut -f 2 -d':')"
        service="$(echo $service | cut -f 1 -d':')"
    else
        port="8881"
    fi
    log -i "TEST Service $service is on port $port"
    var -k tuner.port -a "$port" -v "$service"

    for channel in $(var -k iptv.channel "$service")
    do
        log -i "Preparing $channel"
        cat /app/iptv/supervisord.template.conf | sed 's/{channel}/'$channel'/g' >> /app/iptv/supervisord.conf
    done
done

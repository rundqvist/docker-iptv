#!/bin/sh

channel=$1
log -i nginx "Stream $channel starting."

url=$(var -k urls $channel);

if [ -z "$url" ]
then
    log -e iptv "Channel '$channel' not supported."
    
    exit 1;
fi

cleanUp ()
{
    # kill all children
    pkill -KILL -P $$
}

trap 'cleanUp' TERM

if [ -z "$url"]
then
    streamlink -O \
        --stream-segment-attempts 1000 \
        --stream-segment-timeout 60 \
        --hls-segment-attempts 1000 \
        --hls-segment-timeout 60 \
        --retry-open 1000 \
        --retry-streams 60 \
        --tvplayer-email "$(var TVPLAYER_EMAIL)" \
        --tvplayer-password "$(var TVPLAYER_PASSWORD)" \
        "$url" best | \
        ffmpeg -re -i - -c:a copy -c:v libx264 -b:v 2500k -f flv -g 30 -r 30 -s 1280x720 -preset superfast -profile:v baseline rtmp://127.0.0.1:1935/live/$channel &
else
    ffmpeg -re -i $url -c:a copy -c:v libx264 -b:v 2500k -f flv -g 30 -r 30 -s 1280x720 -preset superfast -profile:v baseline rtmp://127.0.0.1:1935/live/$channel &
fi

wait

exit 0;

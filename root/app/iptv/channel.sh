#!/bin/sh

channel="$1"
port=$(var -k channel.port "$channel")
url=$(var -k channel.url "$channel")

log -i ffmpeg "Starting $channel at port $port."


ffmpeg -i "$url" -bsf:v h264_mp4toannexb -c copy -f mpegts -listen 1 http://127.0.0.1:$port/

log -i ffmpeg "Stopped $channel."
exit 0;
# http://192.168.0.11:1935/live/11101.ts
# http://192.168.0.11:8880/epg.xml
# http://192.168.0.11:8880/playlist.m3u8
# http://192.168.0.11:8881/

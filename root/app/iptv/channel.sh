#!/bin/sh

channel="$1"
port=$(var -k iptv.port "$channel")
url=$(var -k iptv.url "$channel")

log -i ffmpeg "Starting $channel at port $port."


ffmpeg -i "$url" -bsf:v h264_mp4toannexb -c copy -f mpegts -listen 1 http://127.0.0.1:$port/

log -i ffmpeg "Stopped $channel."
exit 0;
# http://192.168.0.11:1935/live/11101.ts
# http://192.168.0.11:8888/iptv/epg.xml
# http://192.168.0.11:8888/iptv/playlist.m3u8
# http://192.168.0.11:8889/

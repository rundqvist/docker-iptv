#!/bin/sh

channel="$1"
port=$(var -k iptv.port "$channel")
url=$(var -k urls "$channel")

log -i ffmpeg "Starting $channel at port $port."


ffmpeg -i "$url" -bsf:v h264_mp4toannexb -c copy -f mpegts -listen 1 http://127.0.0.1:$port/

log -i ffmpeg "Stopped $channel."

# http://192.168.0.11:1935/live/11101.ts

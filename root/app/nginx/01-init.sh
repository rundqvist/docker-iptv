#!/bin/sh

function add
{
    id="$1"
    port="$2"
    name="$3"
    url="$4"

    log -d "Adding channel $id ($name) $port $url"

    var -k iptv.url "$id" "$url"
    var -k iptv.port "$id" "$port"
    var -k iptv.name "$id" "$name"
}

add svt1.svt.se 11001 "SVT 1" "https://svt1-a.akamaized.net/se/svt1/master.m3u8?defaultSubLang=1"
add svt2.svt.se 11002 "SVT 2" "https://svt2-a.akamaized.net/se/svt2/master.m3u8?defaultSubLang=1"

add nrk1.nrk.no 11001 "NRK 1" "https://nrk-nrk1.akamaized.net/21/1/hls/nrk_1/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"
add nrk2.nrk.no 11102 "NRK 2" "https://nrk-nrk2.akamaized.net/22/1/hls/nrk_2/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"

#!/bin/sh

function add
{
    service="$1"
    channel="$2"
    name="$3"
    url="$4"

    position=$(var -k iptv.position $service | sed -e :a -e 's/^.\{1,2\}$/0&/;ta')
    port="10$position"

    log -d "Adding channel $channel ($position $name) $port $url"

    var -k iptv.channel -a "$service" -v "$channel"
    var -k channel.url "$channel" "$url"
    var -k channel.position "$channel" "$position"
    var -k channel.port "$channel" "$port"
    var -k channel.name "$channel" "$name"

    var -k iptv.position $service + 1
}

var -k iptv.position svtplay.se 0
var -k iptv.position nrk.no 10
var -k iptv.position dr.dk 20
var -k iptv.position yle.fi 30

add svtplay.se svt1.svt.se "SVT1" "https://svt1-a.akamaized.net/se/svt1/master.m3u8?defaultSubLang=1"
add svtplay.se svt2.svt.se "SVT2" "https://svt2-a.akamaized.net/se/svt2/master.m3u8?defaultSubLang=1"
add svtplay.se kunskapskanalen.svt.se "Kunskapskanalen" "https://svtk-a.akamaized.net/se/svtk/master.m3u8?defaultSubLang=1"
add svtplay.se svtb-svt24.svt.se "SVTB/SVT24" "https://svtb-a.akamaized.net/se/svtb/master.m3u8?defaultSubLang=1"

add nrk.no nrk1.nrk.no "NRK1" "https://nrk-nrk1.akamaized.net/21/1/hls/nrk_1/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"
add nrk.no nrk2.nrk.no "NRK2" "https://nrk-nrk2.akamaized.net/22/1/hls/nrk_2/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"
add nrk.no nrk3.nrk.no "NRK3" "https://nrk-nrk3.akamaized.net/23/1/hls/nrk_3/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"

add dr.dk dr1.dr.dk "DR1" "https://drlive01hls.akamaized.net/hls/live/2014185/drlive01/master.m3u8"
add dr.dk dr2.dr.dk "DR2" "https://drlive02hls.akamaized.net/hls/live/2014187/drlive02/master.m3u8"
add dr.dk ramasjang.dr.dk "Ramasjang" "https://drlive03hls.akamaized.net/hls/live/2014190/drlive03/master.m3u8"

add yle.fi tv1.yle.fi "YLE1" "https://yletv-lh.akamaihd.net/i/yletv1hls_1@103188/master.m3u8?__b__=1064&dw=14400&set-segment-duration=quality"
add yle.fi tv2.yle.fi "YLE2" "https://yletv-lh.akamaihd.net/i/yletv2hls_1@103189/master.m3u8?__b__=1064&dw=14400&set-segment-duration=quality"
add yle.fi fem.yle.fi "YLE Teema/Fem" "https://yletv-lh.akamaihd.net/i/yleteemafemfi_1@490775/master.m3u8?__b__=1064&dw=14400&set-segment-duration=quality"
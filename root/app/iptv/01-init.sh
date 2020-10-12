#!/bin/sh

function add
{
    service="$1"
    id="$2"
    port="$3"
    name="$4"
    url="$5"

    log -d "Adding channel $id ($name) $port $url"

    var -k iptv.channel -a "$service" -v "$id"
    var -k channel.url "$id" "$url"
    var -k channel.port "$id" "$port"
    var -k channel.name "$id" "$name"
}

add svtplay.se svt1.svt.se 11001 "SVT1" "https://svt1-a.akamaized.net/se/svt1/master.m3u8?defaultSubLang=1"
add svtplay.se svt2.svt.se 11002 "SVT2" "https://svt2-a.akamaized.net/se/svt2/master.m3u8?defaultSubLang=1"
add svtplay.se kunskapskanalen.svt.se 11003 "Kunskapskanalen" "https://svtk-a.akamaized.net/se/svtk/master.m3u8?defaultSubLang=1"
add svtplay.se svtb-svt24.svt.se 11004 "SVTB/SVT24" "https://svtb-a.akamaized.net/se/svtb/master.m3u8?defaultSubLang=1"

add nrk.no nrk1.nrk.no 11101 "NRK1" "https://nrk-nrk1.akamaized.net/21/1/hls/nrk_1/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"
add nrk.no nrk2.nrk.no 11102 "NRK2" "https://nrk-nrk2.akamaized.net/22/1/hls/nrk_2/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"
add nrk.no nrk3.nrk.no 11103 "NRK3" "https://nrk-nrk3.akamaized.net/23/1/hls/nrk_3/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"

add dr.dk dr1.dr.dk 11201 "DR1" "https://drlive01hls.akamaized.net/hls/live/2014185/drlive01/master.m3u8"
add dr.dk dr2.dr.dk 11202 "DR2" "https://drlive02hls.akamaized.net/hls/live/2014187/drlive02/master.m3u8"
add dr.dk ramasjang.dr.dk 11203 "Ramasjang" "https://drlive03hls.akamaized.net/hls/live/2014190/drlive03/master.m3u8"

add yle.fi tv1.yle.fi 11301 "YLE1" "https://yletv-lh.akamaihd.net/i/yletv1hls_1@103188/master.m3u8?__b__=1064&dw=14400&set-segment-duration=quality"
add yle.fi tv2.yle.fi 11302 "YLE2" "https://yletv-lh.akamaihd.net/i/yletv2hls_1@103189/master.m3u8?__b__=1064&dw=14400&set-segment-duration=quality"
add yle.fi fem.yle.fi 11303 "YLE Teema/Fem" "https://yletv-lh.akamaihd.net/i/yleteemafemfi_1@490775/master.m3u8?__b__=1064&dw=14400&set-segment-duration=quality"
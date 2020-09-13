#!/bin/sh

mkdir -p /www/

var -k urls svt1.svt.se "https://svt1-a.akamaized.net/se/svt1/master.m3u8?defaultSubLang=1"
var -k urls svt2.svt.se "https://svt2-a.akamaized.net/se/svt2/master.m3u8?defaultSubLang=1"
var -k urls nrk1.nrk.no "https://nrk-nrk1.akamaized.net/21/1/hls/nrk_1/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"

exit 0;

#EXTM3U x-tvg-url="http://i.mjh.nz/nzau/epg.xml.gz"
#EXTINF:-1 tvg-id="tv.101002210221" tvg-name="ABC" tvg-language="English" tvg-logo="https://www.abc.net.au/tv/epg/images/channels/ABC1_60x53.png" group-title="News",ABC
https://i.mjh.nz/au/Brisbane/tv.101002410241.m3u8
#EXTINF:-1 tvg-id="tv.101002210222" tvg-name="ABC COMEDY/ABC KIDS NSW" tvg-language="English" tvg-logo="https://www.abc.net.au/tv/epg/images/channels/ABC2_76x37.png" group-title="News",ABC Comedy
https://i.mjh.nz/au/Brisbane/tv.abc2.m3u8
#!/bin/sh

mkdir -p /www/

> /www/playlist.m3u8
echo "#EXTM3U x-tvg-url=\"http://$(var HOST_IP):8888/iptv/epg.xml\"" >> /www/playlist.m3u8

for service in $(var IPTV_SERVICES)
do
    log -v playlist "Adding service $service"
    for channel in $(var -k channels $service)
    do
        log -v playlist "Adding channel $channel"
        echo "#EXTINF:-1 tvg-id=\"$channel\",$channel" >> /www/playlist.m3u8
        echo "rtmp://$(var HOST_IP):1935/live/$channel" >> /www/playlist.m3u8
    done
done

exit 0;

echo "" >> /www/playlist.m3u8
echo "#EXTINF:-1 tvg-id=\"svt2.svt.se\" tvg-name=\"svt2.svt.se\" tvg-language=\"Svenska\" group-title=\"Nyheter\",SVT 2" >> /www/playlist.m3u8
echo "https://svt2-a.akamaized.net/se/svt2/master.m3u8?defaultSubLang=1" >> /www/playlist.m3u8
echo "" >> /www/playlist.m3u8
echo "#EXTINF:-1 tvg-id=\"nrk1.nrk.no\" tvg-name=\"nrk1.nrk.no\" tvg-language=\"Norska\" group-title=\"Nyheter\",NRK 1" >> /www/playlist.m3u8
echo "https://nrk-nrk1.akamaized.net/21/1/hls/nrk_1/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only" >> /www/playlist.m3u8

exit 0;

#EXTM3U x-tvg-url="http://i.mjh.nz/nzau/epg.xml.gz"
#EXTINF:-1 tvg-id="tv.101002210221" tvg-name="ABC" tvg-language="English" tvg-logo="https://www.abc.net.au/tv/epg/images/channels/ABC1_60x53.png" group-title="News",ABC
https://i.mjh.nz/au/Brisbane/tv.101002410241.m3u8
#EXTINF:-1 tvg-id="tv.101002210222" tvg-name="ABC COMEDY/ABC KIDS NSW" tvg-language="English" tvg-logo="https://www.abc.net.au/tv/epg/images/channels/ABC2_76x37.png" group-title="News",ABC Comedy
https://i.mjh.nz/au/Brisbane/tv.abc2.m3u8
#!/bin/sh

hostIp="$(var HOST_IP)"
var deviceId 12348200

for port in $(var -k tuner.port)
do
var deviceId + 1
friendlyName="IPTV $port"
manufacturer="Silicondust"
modelName="HDHR-2US"
modelNumber="HDHR-2US"
serialNumber=""
deviceAuth="iptv$port"
baseUrl="http://$hostIp:$port"
lineupUrl="$baseUrl/lineup.json"

mkdir -p /www/$port/

cat << EOF > /www/$port/device.xml
<root xmlns="urn:schemas-upnp-org:device-1-0">
    <specVersion>
        <major>1</major>
        <minor>0</minor>
    </specVersion>
    <URLBase>$baseUrl</URLBase>
    <device>
        <deviceType>urn:schemas-upnp-org:device:MediaServer:1</deviceType>
        <friendlyName>$friendlyName</friendlyName>
        <manufacturer>$manufacturer</manufacturer>
        <modelName>$modelName</modelName>
        <modelNumber>$modelNumber</modelNumber>
        <serialNumber>$serialNumber/serialNumber>
        <UDN>uuid:$(var deviceId)</UDN>
    </device>
</root>
EOF

cat << EOF > /www/$port/discover.json
{
    "FriendlyName":"$friendlyName",
    "Manufacturer":"$manufacturer",
    "ModelNumber":"$modelNumber",
    "FirmwareName":"hdhomeruntc_atsc",
    "TunerCount":1,
    "FirmwareVersion":"20150826",
    "DeviceID":"$(var deviceId)",
    "DeviceAuth":"$deviceAuth",
    "BaseURL":"$baseUrl",
    "LineupURL":"$lineupUrl"
}
EOF

cat << EOF > /www/$port/lineup_status.json
{"ScanInProgress":0,"ScanPossible":1,"Source":"Cable","SourceList":["Cable"]}
EOF

var -d delimiter
echo "[" > /www/$port/lineup.json
for service in $(var -k tuner.port $port)
do
    for channel in $(var -k iptv.channel $service)
    do
cat << EOF >> /www/$port/lineup.json
$(var delimiter){"GuideNumber":"$(var -k channel.position $channel)","GuideName":"$(var -k channel.name $channel)","URL":"http://$(var HOST_IP):1935/$(var -k channel.port $channel).ts"}
EOF
var delimiter ","
    done
done
echo "]" >> /www/$port/lineup.json

done
#!/bin/sh

hostIp="$(var HOST_IP)"

friendlyName="Rundqvist IPTV"
manufacturer="Silicondust"
modelName="HDHR-2US"
modelNumber="HDHR-2US"
serialNumber=""
deviceId="12348201"
deviceAuth="rundqvist"
baseUrl="http://$hostIp:8888"
lineupUrl="$baseUrl/lineup.json"

mkdir /www/

cat << EOF > /www/device.xml
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
        <UDN>uuid:$deviceId</UDN>
    </device>
</root>
EOF

cat << EOF > /www/discover.json
{
    "FriendlyName":"$friendlyName",
    "Manufacturer":"$manufacturer",
    "ModelNumber":"$modelNumber",
    "FirmwareName":"hdhomeruntc_atsc",
    "TunerCount":1,
    "FirmwareVersion":"20150826",
    "DeviceID":"$deviceId",
    "DeviceAuth":"$deviceAuth",
    "BaseURL":"$baseUrl",
    "LineupURL":"$lineupUrl"
}
EOF

cat << EOF > /www/lineup_status.json
{"ScanInProgress":0,"ScanPossible":1,"Source":"Cable","SourceList":["Cable"]}
EOF

echo "[" > /www/lineup.json
for service in $(var IPTV_SERVICES)
do
    for channel in $(var -k iptv.channel $service)
    do
cat << EOF >> /www/lineup.json
$(var comma){"GuideNumber":"$(var -k iptv.port $channel)","GuideName":"$(var -k iptv.name $channel)","URL":"http://$(var HOST_IP):1935/$(var -k iptv.port $channel).ts"}
EOF
var comma ","
    done
done
echo "]" >> /www/lineup.json
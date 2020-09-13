#!/bin/sh

DAEMON=0
if [ "$1" = "--as-daemon" ] ; then 
    DAEMON=1; 
fi

CACHE_PATH="/cache/iptv/"
EPG_CACHE_PATH=$CACHE_PATH"epg/"
mkdir -p $EPG_CACHE_PATH

while [ $DAEMON -eq 1 ] ; do

    #
    # Download epg
    #
    for service in $(var IPTV_SERVICES) ; do

        provider="$(var -k provider $service)"
        format="$(var -k format $provider)"
        log -i iptv "Provider: $provider"
        log -i iptv "Format: $format"
        
        count=0
        while [ $count -ne $(var IPTV_DAYS) ] ; do

            filedate=$(date +%Y-%m-%d -d "+$count day")
            
            for channel in $(var -k channels $service) ; do
                url=$(echo "$format" | sed -e "s/{provider}/$provider/" -e "s/{channel}/$channel/" -e "s/{date}/$filedate/")
                file=${url##*/}

                if [ ! -f $EPG_CACHE_PATH$file ] ; then
                    log -i iptv "download: $url to $EPG_CACHE_PATH$file"

                    wget -P $EPG_CACHE_PATH $url
                    #download: http://xmltv.xmltv.se/svt1.svt.se_2020-09-13.xml to /cache/iptv/epg/svt1.svt.se_2020-09-13.xml
                else
                    log -i iptv "file $EPG_CACHE_PATH$file exists"
                fi

            done

            count=$(expr $count + 1)
        done

    done

    #
    # Create main epg file
    #
    rm -f $CACHE_PATH"epg.xml"

    for file in $(ls $EPG_CACHE_PATH) ; do
        if [ -f $CACHE_PATH"epg.xml" ] ; then

            log -i iptv "Merging $file"
            tv_merge -i $CACHE_PATH"epg.xml" -m $EPG_CACHE_PATH$file -o $CACHE_PATH"epg.xml"

        else

            log -i iptv "Copying $file"
            cp $EPG_CACHE_PATH$file $CACHE_PATH"epg.xml"

        fi
    done

    sleep 600;
done
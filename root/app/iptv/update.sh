#!/bin/sh

DAEMON=0
if [ "$1" = "--as-daemon" ] ; then 
    DAEMON=1; 
fi

CACHE_PATH="/cache/iptv/"
EPG_CACHE_PATH=$CACHE_PATH"epg/"
EPG_OUTPUT_PATH=$CACHE_PATH
mkdir -p $EPG_CACHE_PATH
mkdir -p $EPG_OUTPUT_PATH

while [ $DAEMON -eq 1 ] ; do

    #
    # Download epg
    #
    if [ "$(var epgUpdatedDate)" != "$(date +%Y-%m-%d)" ] ; then

        log -i iptv "Updating EPG"
        log -d iptv "Last update was: $(var epgUpdatedDate)"

        for service in $(var IPTV_SERVICES) ; do

            provider="$(var -k provider $service)"
            format="$(var -k format $provider)"
            log -v iptv "Service: $service, provider: $provider, format: $format"
            
            count=0
            while [ $count -ne $(var IPTV_DAYS) ] ; do

                filedate=$(date +%Y-%m-%d -d "+$count day")
                
                for channel in $(var -k channels $service) ; do
                    url=$(echo "$format" | sed -e "s/{provider}/$provider/" -e "s/{channel}/$channel/" -e "s/{date}/$filedate/")
                    file=${url##*/}

                    if [ ! -f $EPG_CACHE_PATH$file ] ; then

                        log -v iptv "Download: $url to $EPG_CACHE_PATH$file"
                        wget -P $EPG_CACHE_PATH $url

                        if [ $? -eq 0 ] ; then
                            var epgUpdated true
                            var epgUpdatedDate $(date +%Y-%m-%d)
                        else
                            log -e iptv "Failed to download $url"
                        fi
                        
                    else
                        log -v iptv "file $EPG_CACHE_PATH$file exists"
                    fi

                done

                count=$(expr $count + 1)
            done

        done

    else
        log -v iptv "EPG recently updated ($(var epgUpdatedDate)). Skipping."
    fi

    #
    # Delete old files
    #
    files=$(find $EPG_CACHE_PATH -type f -mtime +$(var IPTV_DAYS) -print)
    count=$(echo "$files" | sed '/^\s*$/d' | wc -l)
    
    log -d iptv "Deleting epg older than $(var IPTV_DAYS) days ($count files)"

    for file in $files ; do
        log -v iptv "Deleting file: $file"
        rm -f $file
    done

    #
    # Create main epg file if updated or file doesn't exist
    #
    if [ "$(var epgUpdated)" = "true" ] || [ ! -f $EPG_OUTPUT_PATH"epg.xml" ] ; then

        log -d "Merging epg"

        rm -f $EPG_OUTPUT_PATH"epg-tmp.xml"

        for file in $(ls $EPG_CACHE_PATH) ; do
            if [ -f $EPG_OUTPUT_PATH"epg-tmp.xml" ] ; then

                log -v iptv "Merging $file"
                tv_merge -i $EPG_OUTPUT_PATH"epg-tmp.xml" -m $EPG_CACHE_PATH$file -o $EPG_OUTPUT_PATH"epg-tmp.xml"

            else

                log -v iptv "Copying $file"
                cp $EPG_CACHE_PATH$file $EPG_OUTPUT_PATH"epg-tmp.xml"

            fi
        done

        log -v "Moving "$EPG_OUTPUT_PATH"epg-tmp.xml to "$EPG_OUTPUT_PATH"epg.xml"
        mv -f $EPG_OUTPUT_PATH"epg-tmp.xml" $EPG_OUTPUT_PATH"epg.xml"

    else
        log -d "No updates. Skipping merge."
    fi

    var epgUpdated false

    sleep 600;
done
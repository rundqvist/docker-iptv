#!/bin/sh

CACHE_PATH="/cache/iptv/"
EPG_CACHE_PATH=$CACHE_PATH"epg/"
EPG_OUTPUT_PATH="/www/"
mkdir -p $EPG_CACHE_PATH
mkdir -p $EPG_OUTPUT_PATH

format="http://{provider}/{channel}_{date}.xml"

while [ "$(var -k epgDaemon xmltv.se)" = "true" ] ; do

    #
    # Download epg
    #
    if [ "$(var epgUpdatedDate)" != "$(date +%Y-%m-%d)" ]
    then

        log -i epg "Updating EPG"
        log -d epg "Last update was: $(var epgUpdatedDate)"

        for service in $(var IPTV_SERVICES)
        do
            provider="$(var -k provider $service)"
            log -v epg "Service: $service, provider: $provider, format: $format"
            
            count=0
            while [ $count -ne $(var IPTV_DAYS) ] ; do

                filedate=$(date +%Y-%m-%d -d "+$count day")
                
                for channel in $(var -k iptv.channel $service)
                do

                    rm -f $CACHE_PATH"channel_$channel.xml"
                    name=$(var -k channel.name "$channel")

cat << EOF > $CACHE_PATH"channel_$channel.xml"
<channel id="$channel">
  <display-name>$name</display-name>
  <icon src="https://chanlogos.xmltv.se/$channel.png" />
</channel>
EOF

                    url=$(echo "$format" | sed -e "s/{provider}/$provider/" -e "s/{channel}/$channel/" -e "s/{date}/$filedate/")
                    file=${url##*/}

                    if [ ! -f $EPG_CACHE_PATH$file ] ; then

                        log -v epg "Download: $url to $EPG_CACHE_PATH$file"
                        wget -P $EPG_CACHE_PATH $url

                        if [ $? -eq 0 ] ; then
                            var epgUpdated true
                            var epgUpdatedDate $(date +%Y-%m-%d)
                        else
                            log -e epg "Failed to download $url"
                        fi
                        
                    else
                        log -v epg "file $EPG_CACHE_PATH$file exists"
                        touch $EPG_CACHE_PATH$file
                    fi

                done

                count=$(expr $count + 1)
            done

        done

    else
        log -v epg "EPG recently updated ($(var epgUpdatedDate)). Skipping."
    fi

    #
    # Delete old files
    #
    files=$(find $EPG_CACHE_PATH -type f -mtime +0 -print)
    count=$(echo "$files" | sed '/^\s*$/d' | wc -l)
    
    log -d epg "Deleting old epg ($count files)"

    for file in $files ; do
        log -v epg "Deleting file: $file"
        rm -f $file
    done

    if [ ! -f $EPG_OUTPUT_PATH"epg.xml" ] && [ -f $CACHE_PATH"epg.xml" ]
    then
        cp -f $CACHE_PATH"epg.xml" $EPG_OUTPUT_PATH"epg.xml"
    fi

    #
    # Create main epg file if updated or file doesn't exist
    #
    if [ "$(var epgUpdated)" = "true" ] || [ ! -f $CACHE_PATH"epg.xml" ] ; then

        log -d epg "Merging..."

        rm -f $CACHE_PATH"epg-tmp.xml"

        for file in $(ls $EPG_CACHE_PATH)
        do
            if [ -f $CACHE_PATH"epg-tmp.xml" ]
            then
                log -v epg "Merging $file"
                tv_merge -i $CACHE_PATH"epg-tmp.xml" -m $EPG_CACHE_PATH$file -o $CACHE_PATH"epg-tmp.xml"
            else
                log -v epg "Copying $file"
                cp $EPG_CACHE_PATH$file $CACHE_PATH"epg-tmp.xml"
            fi
        done

        # Add rowbreak between <tv> and <programme>
        sed -i 's/<tv\([^>]*\)></<tv\1>\n</' $CACHE_PATH"epg-tmp.xml"
        
        # Add channels to xml
        for file in $(ls $CACHE_PATH"channel_"*)
        do
            log -d "Adding channel: $file"
            sed -e "/<tv\([^>]*\)>/r $file" -i -e '$G:x' $CACHE_PATH"epg-tmp.xml"
        done

        log -v "Moving "$CACHE_PATH"epg-tmp.xml to "$CACHE_PATH"epg.xml"
        mv -f $CACHE_PATH"epg-tmp.xml" $CACHE_PATH"epg.xml"

        cp -f $CACHE_PATH"epg.xml" $EPG_OUTPUT_PATH"epg.xml"
    else
        log -d "No updates. Skipping merge."
    fi

    var epgUpdated false

    sleep 600;
done

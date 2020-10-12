#!/bin/sh

chmod +x "/app/epg/xmltv.se.sh"

var -k provider svtplay.se xmltv.xmltv.se
var -k provider nrk.no xmltv.xmltv.se
var -k provider dr.dk xmltv.xmltv.se
var -k provider yle.fi xmltv.xmltv.se

var -k epgDaemon xmltv.se true

# https://chanlogos.xmltv.se
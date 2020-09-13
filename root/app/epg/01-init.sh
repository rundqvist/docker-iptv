#!/bin/sh

chmod +x /app/epg/update.sh

var -k provider svt.se xmltv.xmltv.se
var -k provider nrk.no xmltv.xmltv.se

var -k format xmltv.xmltv.se "http://{provider}/{channel}_{date}.xml"

var -k channels svt.se svt1.svt.se
var -k channels -a svt.se -v svt2.svt.se

var -k channels nrk.no nrk1.nrk.no


#!/bin/sh

chmod +x "/app/epg/xmltv.se.sh"

var -k provider svtplay.se xmltv.xmltv.se
var -k provider nrk.no xmltv.xmltv.se

var -k channels svtplay.se svt1.svt.se
var -k channels -a svtplay.se -v svt2.svt.se

var -k channels nrk.no nrk1.nrk.no
var -k channels -a nrk.no -v nrk2.nrk.no

var -k epgDaemon xmltv.se true

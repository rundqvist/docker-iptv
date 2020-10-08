#!/bin/sh

var -k urls svt1.svt.se "https://svt1-a.akamaized.net/se/svt1/master.m3u8?defaultSubLang=1"
var -k urls svt2.svt.se "https://svt2-a.akamaized.net/se/svt2/master.m3u8?defaultSubLang=1"

var -k urls nrk1.nrk.no "https://nrk-nrk1.akamaized.net/21/1/hls/nrk_1/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"
var -k urls nrk2.nrk.no "https://nrk-nrk2.akamaized.net/22/1/hls/nrk_2/playlist.m3u8?bw_low=10&bw_high=3500&bw_start=1200&no_iframes&no_audio_only"

var -k iptv.port svt1.svt.se 11001
var -k iptv.port svt2.svt.se 11002

var -k iptv.port nrk1.nrk.no 11101
var -k iptv.port nrk2.nrk.no 11102

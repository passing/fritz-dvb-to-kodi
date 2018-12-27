# description

script fetches all channel lists (SD, HD, Radio) from a "FRITZ!WLAN Repeater DVB-C", enriches them and merges them into one file.

the resulting file can be used in Kodi with the "IPTV Simple Client" plugin that makes use of the following attributes:
* group-title
* tvg-logo

# usage

provide the hostname or IP address of the repeater as argument:
```
./m3u-logo.pl <host/ip>
```

# example

the following line from the original playlist ...
```
#EXTINF:0,Das Erste HD
```
... gets rewritten to ...
```
#EXTINF:0 group-title="HD" tvg-logo="http://tv.avm.de/tvapp/logos/hd/das_erste_hd.png" tvg-name="Das_Erste_HD",Das Erste HD
```

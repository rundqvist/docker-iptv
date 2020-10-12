#!/bin/sh

cp -f /app/nginx/nginx.conf /etc/nginx/
rm -f /etc/nginx/conf.d/default.conf

cat << EOF > /etc/nginx/conf.d/default.conf
server {
    listen 1935;

    types {
        video/MP2T ts;
    }

    location ~ ^/(.*)\.ts\$ {
        proxy_pass http://127.0.0.1:\$1;
    }
}
EOF

cat << EOF > /etc/nginx/conf.d/iptv.conf
server {
    listen 8880;

    types {
        application/xml xml;
        application/x-mpegURL m3u8;
    }

    location / {
        add_header 'Cache-Control' 'no-cache';
        alias /www/;
    }
}
EOF

for port in $(var -k tuner.port)
do

cat << EOF > /etc/nginx/conf.d/tuner$port.conf
server {
    listen $port;
    
    types {
        application/xml xml;
        text/plain json;
        text/html  html;
        image/gif  gif;
        image/jpeg jpg;
    }

    location / {            
        add_header 'Cache-Control' 'no-cache';
        alias /www/$port/;
    }
}
EOF

done

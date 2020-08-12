FROM alpine:3.12

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

COPY root /

RUN apk add --update --no-cache ffmpeg wget make g++ pcre-dev openssl-dev zlib-dev git
RUN	chmod 755 /app/entrypoint.sh
RUN mkdir /app/build
RUN git clone https://github.com/arut/nginx-ts-module.git /app/build/nginx-ts-module/
RUN wget https://nginx.org/download/nginx-1.18.0.tar.gz -O /app/build/nginx-1.18.0.tar.gz
RUN cd /app/build/; tar -xf nginx-1.18.0.tar.gz
RUN cd /app/build/nginx-1.18.0/; \
    ./configure --with-http_ssl_module --add-module=/app/build/nginx-ts-module; \
    make -j 1; \
    make install

RUN cp -f /app/nginx.conf /usr/local/nginx/conf/
RUN mkdir -p /var/media/hls
RUN cp /app/build/nginx-1.18.0/objs/nginx /usr/sbin/

ENTRYPOINT [ "/app/entrypoint.sh" ]


#TLS SNI support enabled
#configure arguments: --prefix=/var/lib/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx/nginx.pid --lock-path=/run/nginx/nginx.lock --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module=dynamic --with-http_image_filter_module=dynamic --with-http_geoip_module=dynamic --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-http_perl_module=dynamic --with-mail=dynamic --with-mail_ssl_module --with-stream=dynamic --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module=dynamic --with-stream_ssl_preread_module --add-dynamic-module=/home/buildozer/aports/main/nginx/src/njs-0.3.8/nginx --add-dynamic-module=/home/buildozer/aports/main/nginx/src/ngx_devel_kit-0.3.1 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/ngx_cache_purge-2.5 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/nginx-dav-ext-module-3.0.0 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/echo-nginx-module-0.61 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/ngx-fancyindex-0.4.4 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/headers-more-nginx-module-0.33 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/lua-nginx-module-0.10.15 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/lua-upstream-nginx-module-0.07 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/nchan-1.2.7 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/nginx-http-shibboleth-2.0.1 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/redis2-nginx-module-0.15 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/set-misc-nginx-module-0.32 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/nginx-upload-progress-module-0.9.2 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/nginx-upstream-fair-0.1.3 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/nginx-rtmp-module-1.2.1 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/nginx-vod-module-1.25 --add-dynamic-module=/home/buildozer/aports/main/nginx/src/ngx_http_geoip2_module-3.3
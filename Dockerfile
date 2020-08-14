FROM alpine:3.12

LABEL maintainer="mattias.rundqvist@icloud.com"

WORKDIR /app

RUN apk add --update --no-cache ffmpeg wget make g++ pcre-dev openssl-dev zlib-dev git 

RUN mkdir -p /tmp/build \
    && mkdir -p /usr/lib/nginx/modules \
    && mkdir -p /etc/nginx/ \
    && mkdir -p /var/media/hls

RUN git clone https://github.com/arut/nginx-ts-module.git /tmp/build/nginx-ts-module/
RUN wget https://nginx.org/download/nginx-1.18.0.tar.gz -O /tmp/build/nginx-1.18.0.tar.gz
RUN cd /tmp/build/; tar -xf nginx-1.18.0.tar.gz; \
    cd /tmp/build/nginx-1.18.0/; \
    ./configure --with-http_ssl_module --add-module=/tmp/build/nginx-ts-module --prefix=/var/lib/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf --pid-path=/run/nginx/nginx.pid --lock-path=/run/nginx/nginx.lock --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --http-proxy-temp-path=/var/lib/nginx/tmp/proxy --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi --http-scgi-temp-path=/var/lib/nginx/tmp/scgi --with-perl_modules_path=/usr/lib/perl5/vendor_perl --user=nginx --group=nginx --with-threads; \
    make -j 1; \
    make install

RUN addgroup -S nginx && adduser -S nginx -G nginx

RUN mkdir -p /var/lib/nginx/tmp/client_body \
    && mkdir -p /var/lib/nginx \
    && mkdir -p /var/log/nginx/ \
    && mkdir -p /run/nginx/ \
    && chown nginx:nginx /var/log/nginx/
    
RUN cp /tmp/build/nginx-1.18.0/objs/nginx /usr/sbin/

COPY root /

RUN	chmod 755 /app/entrypoint.sh

RUN cp -f /app/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT [ "/app/entrypoint.sh" ]

FROM codeworksio/nginx:1.13.8-20180210

ARG APT_PROXY
ARG APT_PROXY_SSL
ENV NGINX_RTMP_MODULE_VERSION="1.2.1"

RUN set -ex; \
    \
    buildDependencies="\
        build-essential \
        libpcre3-dev \
        libssl-dev \
        zlib1g-dev \
    "; \
    if [ -n "$APT_PROXY" ]; then echo "Acquire::http { Proxy \"http://${APT_PROXY}\"; };" > /etc/apt/apt.conf.d/00proxy; fi; \
    if [ -n "$APT_PROXY_SSL" ]; then echo "Acquire::https { Proxy \"https://${APT_PROXY_SSL}\"; };" > /etc/apt/apt.conf.d/00proxy; fi; \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys "4AB0F789CBA31744CC7DA76A8CF63AD3F06FC659"; \
    echo "deb http://ppa.launchpad.net/jonathonf/ffmpeg-3/ubuntu xenial main" > /etc/apt/sources.list.d/ffmpeg.list; \
    apt-get --yes update; \
    apt-get --yes install \
        $buildDependencies \
        ffmpeg \
    ; \
    cd /tmp; \
    curl -L "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" -o nginx-$NGINX_VERSION.tar.gz; \
    tar -xf nginx-$NGINX_VERSION.tar.gz; \
    curl -L "https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_MODULE_VERSION}.tar.gz" -o nginx-rtmp-module-$NGINX_RTMP_MODULE_VERSION.tar.gz; \
    tar -xf nginx-rtmp-module-$NGINX_RTMP_MODULE_VERSION.tar.gz; \
    \
    cd /tmp/nginx-$NGINX_VERSION; \
    ./configure \
        $(nginx -V 2>&1 | grep 'configure arguments:' | sed 's/configure arguments://g') \
        --add-dynamic-module=/tmp/nginx-rtmp-module-$NGINX_RTMP_MODULE_VERSION; \
    make modules; \
    mkdir -p /usr/local/nginx/modules; \
    cp -v objs/ngx_rtmp_module.so /usr/local/nginx/modules; \
    \
    mkdir -p \
        /var/lib/streaming/hls \
        /var/lib/streaming/dash; \
    chown -R $SYSTEM_USER:$SYSTEM_USER \
        /usr/local/nginx/modules \
        /var/lib/streaming; \
    \
    apt-get purge --yes --auto-remove $buildDependencies; \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/*; \
    rm -f /etc/apt/apt.conf.d/00proxy

COPY assets/ /

VOLUME [ "/var/lib/streaming" ]
EXPOSE 1935 8080 8443
CMD [ "nginx", "-g", "daemon off;" ]

### METADATA ###################################################################

ARG IMAGE
ARG BUILD_DATE
ARG VERSION
ARG VCS_REF
ARG VCS_URL
LABEL \
    org.label-schema.name=$IMAGE \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.version=$VERSION \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=$VCS_URL \
    org.label-schema.schema-version="1.0"

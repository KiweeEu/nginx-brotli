FROM ubuntu:24.04 as builder

RUN apt update \
    && apt upgrade -y \
    && apt install -y libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev wget git gcc make libbrotli-dev

WORKDIR /app
RUN wget https://nginx.org/download/nginx-1.27.4.tar.gz && tar -zxf nginx-1.27.4.tar.gz
RUN git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli
RUN cd nginx-1.27.4 && ./configure --with-compat --add-dynamic-module=../ngx_brotli \
    && make modules

FROM nginx:1.27.5
COPY --from=builder /app/nginx-1.27.4/objs/ngx_http_brotli_static_module.so /etc/nginx/modules/
COPY --from=builder /app/nginx-1.27.4/objs/ngx_http_brotli_filter_module.so /etc/nginx/modules/
RUN echo "load_module modules/ngx_http_brotli_filter_module.so;\nload_module modules/ngx_http_brotli_static_module.so;\n$(cat /etc/nginx/nginx.conf)" > /etc/nginx/nginx.conf
RUN echo 'brotli on;\n \
brotli_comp_level 6;\n \
brotli_static on;\n \
brotli_types application/atom+xml application/javascript application/json application/rss+xml\n \
          application/vnd.ms-fontobject application/x-font-opentype application/x-font-truetype\n \
          application/x-font-ttf application/x-javascript application/xhtml+xml application/xml\n \
          font/eot font/opentype font/otf font/truetype image/svg+xml image/vnd.microsoft.icon\n \
          image/x-icon image/x-win-bitmap text/css text/javascript text/plain text/xml;' > /etc/nginx/conf.d/brotli.conf


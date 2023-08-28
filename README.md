# NGINX with Brotli compression module

## Source

https://github.com/google/ngx_brotli

## Configuration

The module is loaded in `/etc/nginx/nginx.conf`

The default config is located in `/etc/nginx/conf.d/broli.conf`.
In order to override these values this file needs to be replaced.

## Build

```shell
docker build -t kiweeteam/nginx-brotli:latest .
```

## Run

```shell
docker run --name=nginx-brotli --rm -p 80:80 kiweeteam/nginx-brotli:latest
```

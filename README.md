## 使用[docker](https://hub.docker.com/repository/docker/jackywn/olaindex)部署

```shell
docker run -d --init 
--name OLAINDEX 
-p 8000:8000 
-v /data/OLAINDEX:/OLAINDEX 
jackywn/olaindex
```

## 构建容器镜像

```shell
git clone https://github.com/Jack-Ywn/OLAINDEX-docker.git
cd OLAINDEX-docker/build
docker build -t jackywn/olaindex .
```

## Nginx反向代理OLAINDEX容器

```shell
server {
    listen 80;
    listen 443 ssl http2;

    server_name                example.com;
    server_name_in_redirect    on;
    port_in_redirect           on;

    if ( $scheme = http ) { return 301 https://$host$request_uri; }

    ssl_certificate          example.com.cer;
    ssl_certificate_key      example.com.key;

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    #配置CSP头（由于HTTPS页面中混合HTTP静态资源会被浏览器阻止，这是Bug后续在代码中修正后可以无需这段配置）
    add_header Content-Security-Policy "script-src 'self' 'unsafe-inline' cdn.jsdelivr.net cdn.staticfile.org; object-src 'none'; child-src 'self'; frame-ancestors 'self'; upgrade-insecure-requests;";

    location / {
        proxy_pass  http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
    }
}
```

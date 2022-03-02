## 使用[docker](https://hub.docker.com/repository/docker/jackywn/olaindex)部署

```shell
#全新环境初始化部署
docker run -d --init \
--name OLAINDEX \
-p 80:8000 \
-v /data/OLAINDEX:/OLAINDEX \
jackywn/olaindex 

#直接使用已经初始化好数据（由于网络原因导致容器无法下载OLAINDEX源码）
git clone https://github.com/Jack-Ywn/OLAINDEX-docker.git
cd OLAINDEX-docker
mkdir /data
tar xf OLAINDEX.tar.gz -C /data

docker run -d --init \
--name OLAINDEX \
-p 80:8000 \
-v /data/OLAINDEX:/OLAINDEX \
jackywn/olaindex

#访问http://ip/login?redirect=%2Fadmin即可使用OLAINDEX
默认管理员帐号是 admin/123456
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

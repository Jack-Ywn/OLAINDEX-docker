FROM php:7-cli-alpine

ENV LANG=C.UTF-8

WORKDIR /OLAINDEX

RUN apk add --no-cache tzdata git composer && \
    echo "Asia/Shanghai" > /etc/timezone && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del tzdata && \
    docker-php-ext-install bcmath

EXPOSE 8000

COPY start.sh /opt/
RUN chmod +x /opt/start.sh
ENTRYPOINT ["/opt/start.sh"]

VOLUME /OLAINDEX

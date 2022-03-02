#进入工作目录
cd /OLAINDEX

#判断是否安装
if [ "$(ls public/index.php)" ];
then
     echo "OLAINDEX is already installed"
else
git clone --depth 1 https://github.com/WangNingkai/OLAINDEX.git . && \
composer install -vvv && \
composer run install-app 
fi

#配置目录权限
addgroup -g 900 -S olaindex && \
adduser -h /OLAINDEX -s /bin/sh -G olaindex -u 900 -S olaindex && \
chown -R olaindex:olaindex /OLAINDEX && \
chmod 755 /OLAINDEX/storage

#开启PHP服务
php artisan serve --host=0.0.0.0 --port=8000 --tries=0 --no-interaction

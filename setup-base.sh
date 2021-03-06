#!/bin/bash

# 每个服务器都要安装的东西
sudo su

wget -q -O - "$@" http://git.io/vkiUF | bash

apt-get update

# 安装 supervisor, python-software-properties
apt-get install -y supervisor python-software-properties



# 设置数据目录
cd / && mkdir data
cd /data && mkdir -p consul nginx
cd consul && mkdir -p data config

cd /data/nginx && mkdir log


# 安装 consul

cd /usr/bin

wget https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_linux_amd64.zip

yes | unzip ./consul_0.5.2_linux_amd64.zip

rm -f consul_0.5.2_linux_amd64.zip


# 设置consul的supervisor配置文件
cd /etc/supervisor/conf.d
echo [program:consul] >> consul.conf
echo command=consul agent -config-dir=/data/consul/config >> consul.conf



# 添加nginx的PPA
add-apt-repository ppa:nginx/stable

# 添加haproxy的PPA
add-apt-repository ppa:vbernat/haproxy-1.5

# 添加rabbitmq的源
cd /tmp
`echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list`
wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
apt-key add rabbitmq-signing-key-public.asc

apt-get update

# 重新加载supervisor的配置
supervisorctl reload


exit
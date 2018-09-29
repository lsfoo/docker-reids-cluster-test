mkdir redis_cluster && cd redis_cluster
# 创建6个目录作为从属节点文件夹
mkdir slave{1..6}
cd ..
# 从官方下载配置文件
wget http://download.redis.io/redis-stable/redis.conf
# 取消绑定
sed -i "s/bind 127.0.0.1/#bind 127.0.0.1/g" redis.conf
# 关闭保护模式
sed -i "s/protected-mode yes/protected-mode no/g" redis.conf
# 开启集群功能
sed -i "s/# cluster-enabled yes/cluster-enabled yes/g" redis.conf

# 创建docker-compose 配置文件
touch redis_cluster/docker-compose.yml

for((i=1;i<7;i++))
do
# 循环配置每个节点的端口和名称
echo "redis-slave"$i":" >> redis_cluster/docker-compose.yml
echo "  build: ./slave"$i"" >> redis_cluster/docker-compose.yml
echo "  ports:" >> redis_cluster/docker-compose.yml
echo "   - 606"$i":606"$i"" >> redis_cluster/docker-compose.yml
echo "   - 1606"$i":1606"$i"" >> redis_cluster/docker-compose.yml
# 循环创建Dcokerfile

cd redis_cluster/slave$i

touch Dockerfile
echo FROM redis >> Dockerfile
echo COPY redis.conf /usr/local/etc/redis/redis.conf >> Dockerfile
echo RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime >> Dockerfile
echo RUN echo \'Asia/Shanghai\' \>/etc/timezone >> Dockerfile
echo RUN chmod 777 /usr/local/etc/redis/redis.conf >> Dockerfile
echo EXPOSE 606$i >> Dockerfile
echo EXPOSE 1606$i >> Dockerfile
echo CMD \[ \"redis-server\", \"/usr/local/etc/redis/redis.conf\" ] >> Dockerfile


# 循环设置第个节点的配置文件

cp ../../redis.conf ./
sed -i "s/port 6379/port 606$i/g" redis.conf
sed -i "s/pidfile \/var\/run\/redis_6379.pid/pidfile \/var\/run\/redis_606$i.pid/g" redis.conf
sed -i "s/# cluster-config-file nodes-6379.conf/cluster-config-file nodes-606$i.conf/g" redis.conf

cd ..
cd ..
done
pwd
rm redis.conf -f

cd redis_cluster

#清理方便每次测试用

docker stop $(docker ps -a -q)

docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

# redis-trib

docker pull zvelo/redis-trib

docker-compose up --build -d

# 列出IP
docker inspect --format='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)


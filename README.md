# docker-reids-cluster-test

## 使用 
chomd 777 docdocker_redis_cluster.sh
./docdocker_redis_cluster.sh

执行完会运行起来6个配置好的redis集群节点容器

```
docker run --rm -it zvelo/redis-trib create --replicas 1 \
ip1:port1 \
ip2:port2 \
ip3:port2 \
ip4:port3 \
ip5:port4 \
ip6:port5 \

```
`docker exec -it $containerid redis-cli -c -p $post`

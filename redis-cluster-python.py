#!/usr/bin/env python
#coding:utf-8

from rediscluster import StrictRedisCluster
import sys

def redis_cluster():
    redis_nodes =  [{"host":"192.168.0.6","port":"6066"},
                    {"host":"192.168.0.4","port":"6064"}, 
                    {"host":"192.168.0.7","port":"6061"}, 
                    {"host":"192.168.0.5","port":"6062"}, 
                    {"host":"192.168.0.3","port":"6065"}, 
                    {"host":"192.168.0.2","port":"6063"}]
    try:
        redisconn = StrictRedisCluster(startup_nodes=redis_nodes)
    except Exception as e:
        print (e)
        sys.exit(1)

    redisconn.set('name','admin')
    redisconn.set('age',18)
    print ("name is: ", redisconn.get('name'))
    print ("age  is: ", redisconn.get('age'))

redis_cluster()

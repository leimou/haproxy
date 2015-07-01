#!/bin/bash

service haproxy restart

consul-template -consul 127.0.0.1:8500 -template "/etc/haproxy/haproxy.ctmpl:/etc/haproxy/haproxy.cfg:bash /haproxy-reload && cat /etc/haproxy/haproxy.cfg"

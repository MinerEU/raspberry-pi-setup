#!/bin/sh

if [ -a "/root/.kv-bash/pool" ] && [ -a "/root/.kv-bash/worker" ] && [ -a "/root/.kv-bash/password" ]; then
rm -f /root/.kv-bash/*pool;
rm -f /root/.kv-bash/*worker;
rm -f /root/.kv-bash/*password;
fi

if [ -a "/root/.kv-bash/operation" ] ; then
    rm -f /root/.kv-bash/operation;
fi

mv /opt/minereu/etc/.kv-bash/* /root/.kv-bash

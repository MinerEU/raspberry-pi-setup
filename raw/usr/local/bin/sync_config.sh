#!/bin/sh

if [ -f "/root/.kv-bash/pool" ] ; then
rm -f /root/.kv-bash/*pool;
fi
if [ -f "/root/.kv-bash/worker" ] ; then
rm -f /root/.kv-bash/*worker;
fi
if [ -f "/root/.kv-bash/password" ]; then
rm -f /root/.kv-bash/*password;
fi

if [ -f "/root/.kv-bash/operation" ] ; then
    rm -f /root/.kv-bash/operation;
fi

mv /opt/minereu/etc/.kv-bash/* /root/.kv-bash

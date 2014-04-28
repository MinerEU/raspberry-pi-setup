#!/bin/sh

if [ -f "/opt/minereu/etc/.kv-bash/pool" ] ; then
rm -f /root/.kv-bash/*pool;
fi
if [ -f "/opt/minereu/etc/.kv-bash/worker" ] ; then
rm -f /root/.kv-bash/*worker;
fi
if [ -f "/opt/minereu/etc/.kv-bash/password" ]; then
rm -f /root/.kv-bash/*password;
fi

if [ -f "/opt/minereu/etc/.kv-bash/operation" ] ; then
    rm -f /root/.kv-bash/operation;
fi

cp -f /opt/minereu/etc/.kv-bash/* /root/.kv-bash

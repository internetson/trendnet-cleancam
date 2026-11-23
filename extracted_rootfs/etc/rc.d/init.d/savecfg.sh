#!/bin/sh

cd /tmp; tar zcf config.tgz config
echo $"Starting save config by bkcfg:---->"
/sbin/bkcfg -s /tmp/config.tgz

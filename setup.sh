#!/bin/sh
export RTE_SDK=$(pwd)/proc-packet
export RTE_TARGET=arm64-armv8a-linuxapp-gcc
cd proc-packet/
make config T=arm64-armv8a-linuxapp-gcc
make
cd ..
echo 4 > /sys/devices/system/node/node0/hugepages/hugepages-524288kB/nr_hugepages
echo 4 > /sys/devices/system/node/node1/hugepages/hugepages-524288kB/nr_hugepages
modprobe uio
rmmod igb_uio
insmod $RTE_SDK/$RTE_TARGET/kmod/igb_uio.ko
cd FastSwitch
mkdir -p /usr/local/etc/fastswitch
mkdir -p /usr/local/var/run/fastswitch
./boot.sh
CFLAGS='-march=native' ./configure --with-dpdk=$RTE_SDK/$RTE_TARGET
make
make install
#init database
ovsdb-tool create /usr/local/etc/fastswitch/conf.db ./vswitchd/vswitch.ovsschema
#start database
ovsdb-server --remote=punix:/usr/local/var/run/fastswitch/db.sock \
--remote=db:Open_vSwitch,Open_vSwitch,manager_options \
--pidfile --detach
#start 
ovs-vsctl --no-wait init
#start fastswitch
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true
ovs-vswitchd unix: /usr/local/var/run/fastswitch/db.sock -- pidfile -detach

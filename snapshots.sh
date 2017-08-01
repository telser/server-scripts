#/bin/sh

sudo zfs snap -r zroot/usr@`date "+%Y-%m-%d_%H:%M:%S"`
sudo zfs snap -r zroot/var@`date "+%Y-%m-%d_%H:%M:%S"`

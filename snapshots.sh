#/bin/sh

/sbin/zfs snap -r zroot/usr@`date "+%Y-%m-%d_%H:%M:%S"`
/sbin/zfs snap -r zroot/var@`date "+%Y-%m-%d_%H:%M:%S"`

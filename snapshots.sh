#/bin/sh

/sbin/zfs snap -r zroot/usr@`date "+%Y%m%d.%H%M"`
/sbin/zfs snap -r zroot/etc@`date "+%Y%m%d.%H%M"`
/sbin/zfs snap -r zroot/var/log@`date "+%Y%m%d.%H%M"`
/sbin/zfs snap tank/poudriere/data/packages@`date "+%Y%m%d.%H%M"`
/sbin/zfs snap -r tank/poudriere/jails@`date "+%Y%m%d.%H%M"`
/sbin/zfs snap -r tank/poudriere/ports@`date "+%Y%m%d.%H%M"`
/sbin/zfs snap -r tank/vms@`date "+%Y%m%d.%H%M"`

#/bin/sh

/sbin/zfs snap rpool@`date "+%Y-%m-%d_%H:%M:%S"`
/sbin/zfs snap -r rpool/ROOT@`date "+%Y-%m-%d_%H:%M:%S"`
/sbin/zfs snap -r rpool/export@`date "+%Y-%m-%d_%H:%M:%S"`
/sbin/zfs snap -r tank@`date "+%Y-%m-%d_%H:%M:%S"`

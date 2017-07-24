#!/bin/sh

HOSTNAME="$(hostname)"
MAILDOMAIN=silencedpoet.com

/usr/local/bin/lynis --cronjob --auditor "${HOSTNAME} autotest" audit system
/usr/bin/mailx -s "Lynis ${HOSTNAME}" "lynis@${MAILDOMAIN}" </var/log/lynis.log

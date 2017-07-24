#!/bin/sh

HOSTNAME="$(hostname)"
MAILDOMAIN=silencedpoet.com

/usr/local/bin/aide --check > /var/log/aide.log
AIDE_EXIT=$?

if [ $AIDE_EXIT -ne 0 ]; then
  /usr/bin/mailx -s "AIDE ${HOSTNAME} Failure" "aide@${MAILDOMAIN}" </var/log/aide.log
fi

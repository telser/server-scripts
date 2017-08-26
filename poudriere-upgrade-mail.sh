#!/bin/sh

# use a term without color to force text mode from synth
TERM=vt100

# use hostname and maildomain environment variables to be a lame obfuscation
HOSTNAME="$(hostname)"
MAILDOMAIN=silencedpoet.com

# Update the ports tree
/usr/local/bin/poudriere ports -u -p HEAD
PORTS_CODE=$?

if [ $POUDRIERE_CODE -ne 0 ]; then
  /usr/bin/mailx -s "Poudriere port update ${HOSTNAME} Failed!" "poudriere@${MAILDOMAIN}" "Failure"
fi

# Run the bulk update
/usr/local/bin/poudriere ports bulk -j 11-1_release -p HEAD -f /usr/local/etc/poudriere.d/ports.poudriere
POUDRIERE_CODE=$?

if [ $POUDRIERE_CODE -ne 0 ]; then
  /usr/bin/mailx -s "Poudriere bulk rebuild on ${HOSTNAME} Failed" "poudriere@${MAILDOMAIN}"  "Failure"
fi

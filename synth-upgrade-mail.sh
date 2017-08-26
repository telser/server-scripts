#!/bin/sh

# use a term without color to force text mode from synth
TERM=vt100

# use hostname and maildomain environment variables to be a lame obfuscation
HOSTNAME="$(hostname)"
MAILDOMAIN=silencedpoet.com

# Update the ports tree
/usr/sbin/portsnap auto > /var/log/portsnap.log
PORTSNAP_CODE=$?

if [ $PORTSNAP_CODE -ne 0 ]; then
  /usr/bin/mailx -s "Portsnap ${HOSTNAME} Failed!" "portsnap@${MAILDOMAIN}" </var/log/portsnap.log
fi

# Prepare the system to upgraded
/usr/local/bin/synth prepare-system > /var/log/synth-prepare.log
PREP_CODE=$?

if [ $PREP_CODE -ne 0 ]; then
  /usr/bin/mailx -s "Synth ${HOSTNAME} Preparing Failed" "synth@${MAILDOMAIN}" </var/log/synth-prepare.log
fi

# Ensure the repo was really rebuilt for consumption by jails
/usr/local/bin/synth rebuild-repository > /var/log/synth-rebuild.log
REBUILD_CODE=$?

if [ $REBUILD_CODE -ne 0 ]; then
  /usr/bin/mailx -s "Synth ${HOSTNAME} Rebuild Failed" "synth@${MAILDOMAIN}" </var/log/synth-rebuild.log
fi

# Upgrade the system
/usr/local/bin/synth upgrade-system > /var/log/synth-upgrade.log
UPGRADE_CODE=$?

if [ $UPGRADE_CODE -ne 0 ]; then
  /usr/bin/mailx -s "Synth ${HOSTNAME} Upgrading Failed" "synth@${MAILDOMAIN}" </var/log/synth-upgrade.log
fi

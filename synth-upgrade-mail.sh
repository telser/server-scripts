#!/bin/sh

# use a term without color to force text mode from synth
TERM=vt100

# use hostname and maildomain environment variables to be a lame obfuscation
HOSTNAME="$(hostname)"
MAILDOMAIN=silencedpoet.com

# Update the ports tree
/usr/sbin/portsnap auto > /var/log/portsnap.log
/usr/bin/mailx -s "Portsnap ${HOSTNAME} Report" "portsnap@${MAILDOMAIN}" </var/log/portsnap.log

# Prepare the system to upgraded
/usr/local/bin/synth prepare-system > /var/log/synth-prepare.log
/usr/bin/mailx -s "Synth ${HOSTNAME} Preparing" "synth@${MAILDOMAIN}" </var/log/synth-prepare.log

# Upgrade the system
/usr/local/bin/synth upgrade-system > /var/log/synth-upgrade.log
/usr/bin/mailx -s "Synth ${HOSTNAME} Upgrading" "synth@${MAILDOMAIN}" </var/log/synth-upgrade.log

# Ensure the repo was really rebuilt for consumption
/usr/local/bin/synth rebuild-repository > /var/log/synth-upgrade.log
/usr/bin/mailx -s "Synth ${HOSTNAME} Rebuild" "synth@${MAILDOMAIN}" </var/log/synth-upgrade.log

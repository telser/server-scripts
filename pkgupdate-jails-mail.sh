#!/bin/sh

# use hostname and maildomain environment variables to be a lame obfuscation               
HOSTNAME="$(hostname)"                       
MAILDOMAIN=silencedpoet.com
SEND_REPORT=0
UPDATE_REPORT=/var/log/pkg_update_report.log

maybeCatReport() {
  CODE=$1
  UPDATE_HOST=$2
  TMP_REPORT=$3

  if [ $CODE -ne 0 ]; then            
    printf %"s\n" "Now checking versions for ${UPDATE_HOST}" >> $UPDATE_REPORT
    printf %"s\n" "****************************************" >> $UPDATE_REPORT
    SEND_REPORT=1
    cat $TMP_REPORT >> $UPDATE_REPORT
    printf %"s\n\n" "" >> $UPDATE_REPORT
  fi
}

checkJail() {
  JAIL_NUM=$1
  JAIL_HOST=$2
  TMP_UPDATE_REPORT=/tmp/"$JAIL_HOST"-update.log

  pkg -j $JAIL_NUM update
  eval 'pkg -j $JAIL_NUM version -vRUL= > $TMP_UPDATE_REPORT'
  UPDATE_CODE=`wc -l $TMP_UPDATE_REPORT | cut -w -f 2`
  maybeCatReport $UPDATE_CODE $JAIL_HOST $TMP_UPDATE_REPORT
  rm $TMP_UPDATE_REPORT
}

checkHost() {
  TMP_UPDATE_REPORT=/tmp/"$HOSTNAME"-update.log
  
  portsnap auto
  pkg update
  eval 'pkg version -vPUL= > $TMP_UPDATE_REPORT'
  UPDATE_CODE=`wc -l $TMP_UPDATE_REPORT | cut -w -f 2`
  maybeCatReport $UPDATE_CODE $HOSTNAME $TMP_UPDATE_REPORT
  rm $TMP_UPDATE_REPORT
}
  
echo "cleaning up previous update report"
rm $UPDATE_REPORT

JIDS=`jls jid`
for J in $JIDS
do
  JAILHOST=`jls -j $J host.hostname`
  checkJail $J $JAILHOST

done

checkHost
  
if [ $SEND_REPORT -ne 0 ]; then
  /usr/bin/mailx -s "Packages Out Of Date!" "pkgversion@${MAILDOMAIN}" <$UPDATE_REPORT
fi

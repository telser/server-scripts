#!/bin/sh

# use hostname and maildomain environment variables to be a lame obfuscation               
HOSTNAME="$(hostname)"                       
MAILDOMAIN=silencedpoet.com
SEND_REPORT=0
AUDIT_REPORT=/var/log/audit_report.log

maybeCatReport() {
  CODE=$1
  AUDIT_HOST=$2
  TMP_REPORT=$3

  if [ $CODE -ne 0 ]; then            
    printf %"s\n" "Now auditing ${AUDIT_HOST}" >> $AUDIT_REPORT
    printf %"s\n" "*********************************" >> $AUDIT_REPORT
    SEND_REPORT=1
    cat $TMP_REPORT >> $AUDIT_REPORT
    printf %"s\n\n" "" >> $AUDIT_REPORT
  fi
}

auditJail() {
  JAIL_NUM=$1
  JAIL_HOST=$2
  TMP_AUDIT_REPORT=/tmp/"$JAIL_HOST"-audit.log

  pkg -j $JAIL_NUM audit -F > $TMP_AUDIT_REPORT
  AUDIT_CODE=$?                             
  maybeCatReport $AUDIT_CODE $JAIL_HOST $TMP_AUDIT_REPORT
  rm $TMP_AUDIT_REPORT
}

auditHost() {
  TMP_AUDIT_REPORT=/tmp/"$HOSTNAME"-audit.log
  
  pkg audit -F > $TMP_AUDIT_REPORT
  AUDIT_CODE=$?                             
  maybeCatReport $AUDIT_CODE $HOSTNAME $TMP_AUDIT_REPORT
  rm $TMP_AUDIT_REPORT
}
  
echo "cleaning up previous audit report"
rm $AUDIT_REPORT

JIDS=`jls jid`
for J in $JIDS
do
  JAILHOST=`jls -j $J host.hostname`
  auditJail $J $JAILHOST

done

auditHost
  
if [ $SEND_REPORT -ne 0 ]; then
  /usr/bin/mailx -s "Pkg audit Failed!" "pkgaudit@${MAILDOMAIN}" <$AUDIT_REPORT
fi

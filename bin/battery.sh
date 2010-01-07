#!/bin/sh
if grep -q on-line /proc/acpi/ac_adapter/ACAD/state; then
  exit 0
  fi
  
  BAT_DIR=/proc/acpi/battery/BAT1
  FULL_BAT=`grep 'last full capacity' ${BAT_DIR}/info | awk '{ print $4 }'`
  CUR_BAT=`grep 'remaining capacity' ${BAT_DIR}/state | awk '{ print $3 }'`
  AVG=`expr $(expr ${CUR_BAT} \* 100) / ${FULL_BAT}`
  
  if [ "$AVG" -le "90" ]; then
    /usr/bin/showbatt
    fi

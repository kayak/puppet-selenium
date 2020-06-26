#!/bin/bash

# Array magic courtesy of:
# http://unix.stackexchange.com/questions/29509/transform-an-array-into-arguments-of-a-command

process_age_in_minutes(){
  pid=$1
  lstart="$( ps -o lstart= -p $pid )"
  if [[ -z "$lstart" ]]; then
    echo 0
    return 0
  fi

  start=$( date -d "$lstart" +%s )
  now=$( date +%s )
  seconds=$(( $now - $start ))
  echo $(( seconds / 60 ))
}

if [[ $# -ge 1 ]]; then
  MINS_OLD=$1
else
  MINS_OLD=$(( 7 * 60 )) # Default to 6 hours
fi

if [[ -z $CLEANUP_NOOP ]]; then
  SIGNAL=9 # KILL
  ACTION="-print -a -exec rm -rf {} ;"
else
#  set -x
  SIGNAL=0 # NOOP
  ACTION="-print"
fi

to_kill=( chromedriver firefox chrome geckodriver "Web Content")

for killfile in "/opt/google/chrome/chrome"; do
  if [[ -f "${killfile}" ]]; then
    to_kill=( "${to_kill[@]}" "${killfile}" )
  fi
done

for command in "${to_kill[@]}"
do
  for pid in $( ps -eopid=,comm=, | grep "${command}" | awk '{ print $1 }' ); do 
    if [[ "$( process_age_in_minutes $pid )" -gt "$MINS_OLD" ]]; then
      echo "Killing ${pid} $( ps -p $pid -oetime=,comm= )"
      kill -$SIGNAL ${pid}
    fi
  done
done

for regex in \
  "/tmp/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}" \
  "/tmp/\.org\.chromium\.Chromium\.[a-z0-9A-Z]{6}" \
  "/tmp/\.com\.google\.Chrome\.[a-z0-9A-Z]{6}" \
  "/tmp/anonymous[0-9]{10,}webdriver-profile" \
  "/tmp/rust_.*" \
  "/tmp/Temp-.*" \
  "/tmp/webdriver[0-9]{10,}duplicated"; do

  find /tmp -maxdepth 1 \
            -regextype posix-egrep \
            -regex "${regex}" \
            -type d \
            -mmin "+${MINS_OLD}" \
            $ACTION
done

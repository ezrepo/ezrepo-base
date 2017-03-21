#!/bin/sh
#==================================================
# ezpurge.sh
#
# Purge old repository snapshots
#
# USAGE:
#       repopurge.sh -h
#
# REQUIRES: sh,gnu date,rm,ls
#
#==================================================

#========================================
# GLOBAL VARIABLES
#========================================
days_to_retain='120'
dir_snap='/var/www/repos/archive'


#========================================
# FUNCTIONS
#========================================
useage()
{
  echo
  echo "Usage:"
  echo "  $(basename $0) [-h]"
  echo

}


#========================================
# MAIN ()
#========================================

# Find the oldest archive to keep
oldest_date=$(date -d "-${days_to_retain} day" '+%Y%m%d')

# Delete anything older
echo "Removing snapshots older than ${oldest_date}"
echo
for dir in $(ls -1 "${dir_snap}"); do
  if [ "${dir}" -lt "${oldest_date}" ]; then
    echo "Removing: ${dir_snap}/${dir}"
    rm -rf "${dir_snap}/${dir}"
  fi
done

exit 0

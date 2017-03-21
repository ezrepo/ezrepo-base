#!/bin/sh
#==================================================
# ezsnap.sh
#
# Make a hardlink copy of a yum based repo
# All copies must be on same filesystem for this
# to work!
#
# Really just a thin wrapper for rsync.
#
# USAGE:
#       reposnap.sh -h
#
# REQUIRES: sh,rsync,date
#
#==================================================

#========================================
# GLOBAL VARIABLES
#========================================
dir_base='/var/www/repos'
snap_date=`date '+%Y%m%d'`


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
src=${dir_base}/latest
dst=${dir_base}/archive/${snap_date}

if [ -d "${dst}" ]; then
  echo "ERROR: Destination exists: ${snap_date}"
  seconds=$(date '+%H%M%S')
  dst="${dst}-${seconds}"
fi

#----------------------------------------
#..Copy latest repo using hardlinked rpms to save space...
#----------------------------------------
echo "1). Hardlink latest repository rpms to ./archive/${snap_date}"
rsync -az --delete --include="*.rpm" --include="*/" --exclude="*" --link-dest=${src} ${src}/ ${dst}
exitcode=$?
if [ ! ${exitcode} -eq 0 ]; then
  echo "ERROR: rsync completed with error code: ${exitcode}" 1>&2
  exit 1
fi

echo "2). Copy all other files in latest repository to ./archive/${snap_date}"
rsync -az --delete --exclude "*.rpm" ${src}/ ${dst}
exitcode=$?
if [ ! ${exitcode} -eq 0 ]; then
  echo "ERROR: rsync completed with error code: ${exitcode}" 1>&2
  exit 1
fi

exit 0

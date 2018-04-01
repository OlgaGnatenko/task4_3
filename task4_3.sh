#!/bin/bash

if ! [ -d "$1" ]; then
echo "ERR! there is no such directory">&2;
exit;
fi

if [ $# -eq 0 ]
then
echo "ERR! the number of arguments is 0, should be 2">&2;
exit;
fi

if [ $# -gt 2 ] 
then 
echo "ERR! the number of arguments is more than 2, should be 2">&2;
exit;
fi

expr $2 : '-\?[0-9]\+$' >/dev/null && vv=1 || vv=0 
if [ $vv -eq 0 ] 
then
echo "ERR! the second argument is not a number. It should be the number of backups.">&2;
exit;
else
     if [ $2 -lt 0 ]
     then
     echo "ERR! the second parameter should be a number above 0.">&2;
     exit;
     fi
fi

bdir="/tmp/backups/"
if ! [[ -d "${bdir}" ]];
  then
  mkdir "${bdir}"
fi

fdir="${1}"
name=$(echo "${1}" | sed -r 's/[/]+/-/g' | sed 's/^-//')
fname=${name}-$(date '+%Y-%m-%d-%H%M%S').tar.gz

tar --create --gzip  -P --file="$bdir$fname" "${fdir}"

find "$bdir" -name "${name}*" -type f -printf "${bdir}%P\n" | sort -n | head -n  -"$2" | sed "s/.*/\"&\"/" | xargs rm -f

exit 0

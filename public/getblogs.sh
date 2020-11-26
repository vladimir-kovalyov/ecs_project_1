#!/bin/bash

input=./links.txt
o=blogfiles/

cd $o

myarr=($(awk -F':' '{ print $0 }' "$input" | sed -ne '/.txt$/p' -e '/.doc$/p' -e '/.md$/p'))

for i in "${myarr[@]}"
do
  curl --max-filesize 1m $i -O
done
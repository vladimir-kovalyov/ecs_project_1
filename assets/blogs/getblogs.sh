#!/bin/bash

input=./links.txt
o=../../public/blogfiles/

cd $o

myarr=($(awk -F':' '{ print $0 }' "../../assets/blogs/$input" | sed -ne '/.txt$/p' -e '/.doc$/p' -e '/.md$/p'))

for i in "${myarr[@]}"
do
  curl --max-filesize 1m $i -O
done
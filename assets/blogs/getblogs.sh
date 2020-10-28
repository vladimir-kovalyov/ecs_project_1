#!/bin/sh

input=./links.txt
o=blogfiles/

while IFS= read -r line
do
  cd $o
  curl $line -O 
done < "$input"
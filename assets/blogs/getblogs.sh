#!/bin/sh

input=./links.txt
o=blogfiles/

cd $o
while IFS= read -r line
do
  curl $line -O 
done < "../$input"
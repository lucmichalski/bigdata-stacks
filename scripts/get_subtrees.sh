#!/bin/sh

cat ./shared/dataset/list.txt | while read line
do
   # do something with $line here
   name=$(basename $line)
   git subtree add --prefix refs/$name $line master --squash
done

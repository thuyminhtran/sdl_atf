#!/bin/bash

scripts=`ls $1/*.lua`
for f in $scripts
do
   echo "$f" >> "$2_test.log"
   ./start.sh $f 2>&1>> "$2_test.log"
   echo " " >> "$2_test.log"
done
fails=`cat "$2_test.log" | grep FAIL | wc -l`
echo "FAILS - $fails"
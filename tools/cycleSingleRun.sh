#!/bin/bash

for i in $(eval echo {1..$1})
do
   echo "Iteration $i" >> "$2_test_$1.log" 
   echo "========start============" >> "$2_test_$1.log"
   ./start.sh $2 2>&1>> "$2_test_$1.log"
   echo "========End==============" >> "$2_test_$1.log"
done
fails=`cat "$2_test_$1.log" | grep FAIL | wc -l`
echo "FAILS - $fails"
#!/bin/bash

initialNum=180001
count=$2
finalRoll=initialNum+count-1

for (( c=$initialNum; c<=$initialNum+$count-1; c++ ))
do
    echo $c
done

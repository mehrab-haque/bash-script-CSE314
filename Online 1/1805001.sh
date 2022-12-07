#!/bin/bash

lastLine=""
secondToLastLine=""

find "./" -maxdepth 1 -type f -name "*.txt" | while read i
do
    while read -r line; 
    do 
        secondToLastLine="$lastLine"
        lastLine="$line"
    done < "$i"
    mkdir -p "$secondToLastLine"
    cp "$i" "$secondToLastLine"
done
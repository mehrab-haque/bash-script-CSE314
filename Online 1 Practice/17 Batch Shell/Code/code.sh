#!/bin/bash

inputFolderName="classified_01"
currentToken=""

#rm -rf output

function traverse() {
    for file in "$1"/*
    do
        if [ ! -d "${file}" ] ; then
            if grep -q $currentToken "$file"; then
                mkdir -p "output/$currentToken"
                cp $file "output/$currentToken"
            fi
        else
            traverse "${file}"
        fi
    done
}

while read -r line; 
do 
    currentToken=$line
    traverse "$inputFolderName"
done < keywords.txt
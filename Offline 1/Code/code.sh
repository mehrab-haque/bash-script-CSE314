#!/bin/bash

inputZipName="Offline_1_files"
initialRoll=1805121

if [ $# -ge 1 ]
then
    fullMarks=$1
else 
    fullMarks=100
fi

if [ $# -ge 2 ]
then
    rollCount=$2
else 
    rollCount=5
fi



declare -a marks
counter=0

#unzip "$inputZipName.zip"

echo "student_id,score" > "${inputZipName}/output.csv"

for (( c=$initialRoll; c<=$initialRoll+$rollCount-1; c++ ))
do
    if [ -f "${inputZipName}/Submissions/${c}/${c}.sh" ]; then
        marks[$counter]=$fullMarks
        shellOutput=`bash "${inputZipName}/Submissions/${c}/${c}.sh"`
        echo "${shellOutput}" > tmpOutput.txt
        diffResult=`diff -E -Z -b -w -B tmpOutput.txt "${inputZipName}/AcceptedOutput.txt"`
        while IFS= read -r line; do
            if [[ $line == \<* ]] || [[ $line == \>* ]]
            then
                let "marks[counter]-=5"
            fi        
        done <<< "$diffResult"
        if  ((marks[counter]<0));
        then
            let "marks[counter]=0"
        fi  
        rm -rf tmpOutput.txt


        for (( d=$initialRoll; d<=$initialRoll+$rollCount-1; d++ ))
        do
            if (( c != d ))
            then
                if [ -f "${inputZipName}/Submissions/${d}/${d}.sh" ]; 
                then
                    copyDiffResult=`diff -Z -B "${inputZipName}/Submissions/${c}/${c}.sh" "${inputZipName}/Submissions/${d}/${d}.sh"`
                    if [ "$copyDiffResult" == "" ] 
                    then
                        let "marks[counter]=-marks[counter]"
                        break
                    fi
                fi                
            fi
        done


    else 
        marks[$counter]=0
    fi


    echo "${c},${marks[$counter]}" >> "${inputZipName}/output.csv"
    let "counter+=1" 
done


#print marks in shell
echo ${marks[*]}

# for f in ${inputZipName}/Submissions/*; do
#     if [ -d "$f" ]; then
#         folders=(${f//'/'/ })
#         studendId=${folders[2]}
#         shellLoc="${inputZipName}/Submissions/${folders[2]}/${studendId}.sh"
#         bash $shellLoc
#         # $f is a directory
#     fi
# done

#rm -rf $inputZipName
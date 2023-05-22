#!/bin/bash

csv=rats.csv

#while read line
#do
#  d=$(echo $line | awk -F, '{print $3}')
#  sID=$(echo $line | awk -F, '{print $5}')
#  echo $sID $d
#  brkraw info $d | grep DTI | while read s
#  do
#    seq=${s:1:3}
#    echo $seq
#    brkraw tonii -s $seq -o $sID $d
#  done
#done < $csv


for f in *nii.gz
do
  nvols=$(fslnvols $f)
  if [ $nvols -eq 148 ]
  then
  echo "$nvols $f"
    mrconvert -fslgrad ${f%.nii.gz}.{bvec,bval,nii.gz,mif}
    ff=sub-${f:4:2}_dwi
    mrconvert -export_grad_fsl ${ff}{.bvec,.bval} mifs/${f%.nii.gz}.mif ${ff}.nii.gz
  elif [ $nvols -eq 46 ]
  then
    mrconvert -fslgrad ${f%.nii.gz}.{bvec,bval,nii.gz,mif}
    ff=sub-${f:4:2}_dwi
    mrconvert -export_grad_fsl ${ff}{.bvec,.bval} mifs/${f%.nii.gz}.mif ${ff}.nii.gz
  fi
done


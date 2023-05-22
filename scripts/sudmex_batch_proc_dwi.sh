#!/bin/bash

for bvec in *.bvec
do
  im=${bvec%.bvec}.nii.gz
  bval=${bvec%.bvec}.bval
  dim4=$(mrinfo -size $im | awk '{print $4}')
  #echo $dim4
  if [ $dim4 -eq 148 ]
  then
    echolor green "Good data set: $im"
    mrinfo -fslgrad $bvec $bval -bvalue_scaling false -shell_sizes -shell_bvalues $im
    if [ ! -f mifs/${im%.nii.gz}.mif ]; then
       mrconvert -fslgrad $bvec $bval -bvalue_scaling false $im mifs/${im%.nii.gz}.mif
    else
       echolor green "[INFO] File exists: mifs/${im%.nii.gz}.mif"
    fi
  fi
done




for f in mifs/*.mif
do
  ./garza_proc_dwi.sh $f
  
done


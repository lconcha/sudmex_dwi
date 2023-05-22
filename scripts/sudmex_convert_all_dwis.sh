#!/bin/bash

for d in /misc/bruker7/data0?/user/garzalab/*EXVIVO*
do
  echolor green $d
  #brkraw tonii $d
  #ls *bvec
  #rm *.nii.gz *.bvec *.bval
  brkraw info $d | grep DTI | while read s
  do
    seq=${s:1:3}
    echo $seq
    brkraw tonii -s $seq $d
  done
done

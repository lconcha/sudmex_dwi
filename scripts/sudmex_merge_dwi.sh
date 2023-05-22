#!/bin/bash
source `which my_do_cmd`

d=$1
out=$2

tmpDir=$(mktemp -d)

i=0
for f in ${d}/*dwi.nii.gz
do
   my_do_cmd mrconvert -fslgrad ${f%.nii.gz}.{bvec,bval} $f ${tmpDir}/dwi_${i}.mif
    ((i=i+1))
done

my_do_cmd mrcat -axis 3 ${tmpDir}/dwi_*.mif $out

rm -fR $tmpDir


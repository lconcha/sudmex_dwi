#!/bin/bash

dwi=$1
ff=$(basename $dwi)


rbet=/home/inb/lconcha/fmrilab_software/tools/rbet



outfolder=/misc/mansfield/lconcha/exp/sudmex_dwi/exvivo/proc

outbase=${outfolder}/${ff%.mif}

dt=${outbase}_dt.mif
fa=${outbase}_fa.mif
adc=${outbase}_adc.mif
rd=${outbase}_rd.mif
ad=${outbase}_ad.mif
v1=${outbase}_v1.mif
b0=${outbase}_b0.mif


if [ ! -f $fa ]
then
    dwi2tensor -b0 $b0 $dwi $dt
    tensor2metric -fa $fa -adc $adc -rd $rd -ad $ad -vector $v1 $dt
else
  echolor cyan "[INFO] Not repeating dti estimation, file exists: $fa"
fi



mask=${outbase}_mask.nii.gz
if [ ! -f $mask ]
then
    mrconvert $adc /tmp/adc_$$.nii
    $rbet /tmp/adc_$$.nii ${outbase} -v -m -n -R -f 0.3
    rm /tmp/adc_$$.nii
else
  echolor cyan "[INFO] Not repeating mask creation, file exists: $mask"
fi


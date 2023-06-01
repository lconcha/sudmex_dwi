#!/bin/bash
source `which my_do_cmd`
fakeflag=""

dwiIN=$1

bvec=${dwiIN%.nii.gz}.bvec
bval=${dwiIN%.nii.gz}.bval

tmpDir=$(mktemp -d)


dwi=${tmpDir}/dwi.mif
my_do_cmd $fakeflag mrconvert -fslgrad $bvec $bval -bvalue_scaling false $dwiIN $dwi


outfolder=/misc/mansfield/lconcha/exp/sudmex_dwi/exvivo/preproc
denoised=${outfolder}/$(basename ${dwiIN%.nii.gz})_d.mif
denoised_eddy=${outfolder}/$(basename ${dwiIN%.nii.gz})_de.mif
reference=${outfolder}/$(basename ${dwiIN%.nii.gz})_ref.mif




if [ ! -f $denoised ]
then
  my_do_cmd $fakeflag dwidenoise $dwi $denoised
fi


if [ ! -f $denoised_eddy ]
then
  my_do_cmd $fakeflag dwiextract -no_bzero -shell 2000 $denoised ${tmpDir}/b2000s.mif
  my_do_cmd $fakeflag mrmath -axis 3 ${tmpDir}/b2000s.mif mean $reference

  my_do_cmd $fakeflag inb_eddy_correct_sge.sh \
  $denoised \
  $denoised_eddy \
  $reference \
  fsl
else
  echolor green "[INFO] File exists: $denoised_eddy"
fi

rm -fR $tmpDir

# fa=proc/$(basename ${dwi%.mif})_fa.mif
# adc=proc/$(basename ${dwi%.mif})_adc.mif
# v1=proc/$(basename ${dwi%.mif})_v1.mif
# mask=${denoised_eddy%.mif}_mask.mif
# dwi2tensor $denoised_eddy - | tensor2metric -fa $fa -adc $adc -vector $v1 -




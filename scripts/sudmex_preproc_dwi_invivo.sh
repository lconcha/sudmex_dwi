#!/bin/bash

#!/bin/bash

dwi=$1

tmpDir=$(mktemp -d)


denoised=preproc/$(basename ${dwi%.mif})_d.mif
denoised_eddy=preproc/$(basename ${dwi%.mif})_de.mif
reference=preproc/$(basename ${dwi%.mif})_ref.mif

if [ ! -f $denoised ]
then
  dwiextract -no_bzero $dwi $tmpDir/dwis.mif
  dwiextract -shell 2000 $tmpDir/dwis.mif - | mrmath -axis 3 - mean $reference
  dwidenoise -nthreads 6 $tmpDir/dwis.mif $denoised
fi


if [ ! -f $denoised_eddy ]
then
  inb_eddy_correct_sge.sh \
  $denoised \
  $denoised_eddy \
  $reference \
  fsl
else
  echolor green "[INFO] File exists: $denoised_eddy"
fi

rm -fR $tmpDir

fa=proc/$(basename ${dwi%.mif})_fa.mif
adc=proc/$(basename ${dwi%.mif})_adc.mif
v1=proc/$(basename ${dwi%.mif})_v1.mif
mask=${denoised_eddy%.mif}_mask.mif
dwi2tensor $denoised_eddy - | tensor2metric -fa $fa -adc $adc -vector $v1 -




#!/bin/bash

#!/bin/bash

dwi=$1



SUDMEX_DIR=/misc/mansfield/lconcha/exp/sudmex_dwi


#denoised=${SUDMEX_DIR}/invivo/preproc/$(basename ${dwi%.nii.gz})_d.mif
#denoised_eddy=${SUDMEX_DIR}/invivo/preproc/$(basename ${dwi%.nii.gz})_de.mif
outbase=${SUDMEX_DIR}/invivo/preproc/$(basename ${dwi%.nii.gz})



tmpDir=$(mktemp -d)


# Flip the stupid gradients
flip_gradients.sh ${dwi%.nii.gz}.bvec ${tmpDir}/bvecs -flip_x -flip_z
mrconvert \
  -fslgrad ${tmpDir}/bvecs ${dwi%.nii.gz}.bval \
  -export_grad_fsl ${tmpDir}/dwi.{bvec,bval} \
  $dwi \
  ${tmpDir}/dwi.nii.gz



inb_dwi_bruker_preproc.sh \
    -i ${tmpDir}/dwi.nii.gz \
    -o $outbase



rm -fR $tmpDir

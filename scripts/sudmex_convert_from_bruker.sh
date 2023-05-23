#!/bin/bash
source `which my_do_cmd`

csv=data_folders.txt




while read line
do
 subjID=$(echo $line | awk  '{print $1}')
 sessID=$(echo $line | awk  '{print $2}')
 d=$(echo $line | awk  '{print $3}')
 RawData=$(echo $line | awk '{print $5}')
 if [[ "$subjID" == "SubjID" ]]; then echo "first line";continue;fi
 echo $RawData $d
 str=$(echo $d | grep EXVIV)
 vivo="invivo"
 if [ -z "$str" ]; then isexvivo=0; else isexvivo=1;fi
 if [ $isexvivo -eq 1 ]; then echolor green "EXVIVO";vivo="exvivo";fi
 
if [ ! -d $d ]
then
   echolor red "[ERROR] Cannot find $d"
   echo $d >> folders_not_found.txt
fi

 brkraw info $d | grep DTI | while read s
 do
   seq=${s:1:3}
   echo $seq
   outfolder=/misc/mansfield/lconcha/exp/sudmex_dwi/${vivo}/raw

   if [ -f ${outfolder}/${subjID}_${sessID}_dwi.nii.gz ]
   then
     echolor yellow "[INFO] Already converted: ${outfolder}/${subjID}_${sessID}_dwi.nii.gz"
     continue
   fi

   tmpDir=$(mktemp -d)
   my_do_cmd brkraw tonii -s $seq -o ${tmpDir}/dwi $d
   my_do_cmd mrconvert \
     -bvalue_scaling false \
     -export_grad_fsl ${outfolder}/${subjID}_${sessID}_dwi.{bvec,bval} \
     -fslgrad ${tmpDir}/dwi*.{bvec,bval,nii.gz} \
          ${outfolder}/${subjID}_${sessID}_dwi.nii.gz
   rm -fRv $tmpDir
  done
done < $csv


# for f in *nii.gz
# do
#   nvols=$(fslnvols $f)
#   if [ $nvols -eq 148 ]
#   then
#   echo "$nvols $f"
#     mrconvert -fslgrad ${f%.nii.gz}.{bvec,bval,nii.gz,mif}
#     ff=sub-${f:4:2}_dwi
#     mrconvert -export_grad_fsl ${ff}{.bvec,.bval} mifs/${f%.nii.gz}.mif ${ff}.nii.gz
#   elif [ $nvols -eq 46 ]
#   then
#     mrconvert -fslgrad ${f%.nii.gz}.{bvec,bval,nii.gz,mif}
#     ff=sub-${f:4:2}_dwi
#     mrconvert -export_grad_fsl ${ff}{.bvec,.bval} mifs/${f%.nii.gz}.mif ${ff}.nii.gz
#   fi
# done


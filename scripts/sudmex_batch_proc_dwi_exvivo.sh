#!/bin/bash

for dwi in /misc/mansfield/lconcha/exp/sudmex_dwi/exvivo/preproc/*_de.mif
do
  echolor green "$dwi"
  sudmex_proc_exvivo.sh $dwi
done



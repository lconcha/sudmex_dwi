#!/bin/bash

bvec=$1

tbvec=/tmp/tbvec

ff=$(basename $bvec)
fout=${ff}.png

transpose_table.sh $bvec  > $tbvec 

1dplot -xlabel "frame" \
  -ylabel "gradient-amplitude" \
  -ynames x y z \
  -title $ff \
  -png $fout \
  $tbvec 


rm $tbvec
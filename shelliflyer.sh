#!/bin/bash

if [ $# -ne 2 ]
then
  echo "usage: $0 <source> <out>"
  exit
fi
infile=$1
outfile=$2
recursions=0

if [ ! -f "$infile" ]
then
  echo "ERROR: input file '$infile' not found."
  exit
fi

# remove comments except first line
sed '2,$s/#.*//' $infile > $outfile

function cat_src() {
  local srcfile=$1
  echo "scanning $srcfile ..."
  for f in `grep "source .*\.sh" $srcfile| cut -d " " -f2`;
  do
    if grep -q "source .*\.sh" $f
    then
      # nested source -> recursion
      cat_src $f
      recursions=$((recursions + 1))
      echo "recursion: $recursions"
    else
      # no nested includes
      cat $f >> $outfile
    fi
    # cat $f | head -n 5
  done
  cat $srcfile | grep -v "source .*\.sh" >> $outfile
  echo "wrtining file $srcfile ..."
}

cat_src $1

echo ""
echo "finished with $recursions recursions"


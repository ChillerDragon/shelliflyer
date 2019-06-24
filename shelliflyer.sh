#!/bin/bash

if [ $# -ne 2 ]
then
  echo "usage: $0 <source> <out>"
  exit
fi
infile=$1
outfile=$2
recursions=0
cache="/tmp/flyer_cache/"

if [ ! -f "$infile" ]
then
  echo "ERROR: input file '$infile' not found."
  exit
fi

#if [ -d "$cache" ]
#then
#  echo "ERROR: cache directory exist already"
#  exit
#fi
mkdir -p $cache
>$cache/log.txt

function log() {
  echo "$1" >> $cache/log.txt
}

function comments() {
  # remove comments except first line
  sed '2,$s/^#.*//' $infile | # remove start of line comments
  sed '2,$s/[^$]#.*//' # remove inline comments except they are starting with $# ( the arg counter )
}

function cat_src() {
  local srcfile=$1
  log "scanning $srcfile ..."
  for f in `grep "source .*\.sh" $srcfile| cut -d " " -f2`;
  do
    if grep -q "source .*\.sh" $f
    then
      # nested source -> recursion
      cat_src $f
      recursions=$((recursions + 1))
      log "recursion: $recursions"
    else
      # no nested includes
      cat $f >> $outfile
    fi
    # cat $f | head -n 5
  done
  cat $srcfile | grep -v "source .*\.sh"
  log "wrtining file $srcfile ..."
}

cat_src $infile > $cache/cat.sh
comments $cache/cat.sh > $cache/comments.sh
cp $cache/comments.sh $outfile

log ""
log "finished with $recursions recursions"
cat $cache/log.txt


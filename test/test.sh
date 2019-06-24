#!/bin/bash

# Colors
Reset='\033[0m'
Red='\033[0;31m'
Green='\033[0;32m'

run=../../shelliflyer.sh

function assert_equals() {
  d=$(diff <($1) <($2))
  if [ "$d" ]
  then
    echo -e "[${Red}-${Reset}] error:"
    echo "diff: $d"
  else
    echo -e "[${Green}+${Reset}]"
  fi
}

cd comments
# test 1
$run test1.sh out1.sh
chmod +x out1.sh
assert_equals ./test1.sh ./out1.sh
# test 2
$run test2.sh out2.sh
chmod +x out2.sh
assert_equals ./test2.sh ./out2.sh

#!/bin/bash

# Colors
Reset='\033[0m'
Red='\033[0;31m'
Green='\033[0;32m'

run=../../shelliflyer.sh

errors=0
passed=0

function assert_equals() {
  d=$(diff <($1) <($2))
  if [ "$d" ]
  then
    echo -e "[${Red}-${Reset}] error:"
    echo "diff: $d"
    errors=$((errors + 1))
  else
    echo -e "[${Green}+${Reset}]"
    passed=$((passed + 1))
  fi
}

cd comments

$run test1.sh out1.sh
chmod +x out1.sh
assert_equals ./test1.sh ./out1.sh

$run test2.sh out2.sh
chmod +x out2.sh
assert_equals ./test2.sh ./out2.sh

$run test3.sh out3.sh
chmod +x out3.sh
assert_equals ./test3.sh ./out3.sh

echo "---------------------"
echo "tests failed:  $errors"
echo "tests passsed: $passed"

if [ $errors -gt 0 ]
then
    echo -e "[${Red}ERROR${Reset}] test run failed."
else
    echo -e "[${Green}SUCCESS${Reset}] all tests passed."
fi

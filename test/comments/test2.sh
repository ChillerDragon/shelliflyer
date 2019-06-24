#!/bin/bash

# I am a single line comment
echo "foo"
if [ $# -eq 2 ] # check args len
then
  echo "bar"
else
  echo "baz"
fi

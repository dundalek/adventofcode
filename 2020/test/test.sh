#!/usr/bin/env bash

if diff -u test/expected.txt <(test/run.sh)
then
  echo OK
  exit 0
else
  echo
  echo FAIL
  exit 1
fi

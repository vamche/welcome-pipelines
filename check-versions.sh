#!/usr/bin/env bash

# The arguments are tool name, version string, and expected version.
echo "Checking ${1} version..."
if [ "$4" != "" ]; then
  echo "$2 | grep '$3' -2 | grep '$4'"
  COMM=`$2 | grep "$3" -2 | grep "$4"`
else
  echo "$2 | grep '$3'"
  COMM=`$2 | grep "$3"`
fi
if [ $? -ne 0 ]; then
  MESSAGE="Version check failed for $1. Expected $3, got $($2)."
  echo $MESSAGE >> /tmp/version_check_failure
  if [ "$4" != "" ]; then
    echo -e "[FAIL]" `$2 | grep "$3" -2`
  else
    echo -e "[FAIL]" `$2`
  fi
else
  MESSAGE="Version check completed successfully for $1: $3."
  echo $MESSAGE >> /tmp/version_check_success
  echo "[SUCCESS]"
fi
echo ""

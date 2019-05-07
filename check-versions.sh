#!/usr/bin/env bash

# The arguments are tool name, version string, and expected version.
echo "Checking ${1} version..."
if [ "$5" != "" ]; then
  COMMAND=$(echo $($2) | grep "$3" $4 | grep "$5")
else
  COMMAND=$(echo $($2) | grep "$3")
fi
if [ $? -ne 0 ]; then
  MESSAGE="Version check failed for $1. Expected $3, got $($2)."
  echo $MESSAGE >> /tmp/version_check_failure
  echo "[FAIL] $($2 | head -n1)"
else
  MESSAGE="Version check completed successfully for $1: $3."
  echo $MESSAGE >> /tmp/version_check_success
  echo "[SUCCESS] $($2 | head -n1)"
fi
echo ""

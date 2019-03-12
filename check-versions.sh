#!/usr/bin/env bash

# The arguments are tool name, version string, and expected version.
echo -n "Checking ${1} version..."
echo -e $2 | grep $3 > /dev/null 2>&1
exit_code=$?

if [[ $exit_code -ne 0 ]]
then
  MESSAGE="Version check failed for ${1}. Expected ${3}, got ${2}."
  echo $MESSAGE >> /tmp/version_check_failure
  echo "FAIL - Version: ${2}."
else
  MESSAGE="Version check completed successfully for ${1}. Version: ${3}."
  echo $MESSAGE >> /tmp/version_check_success
  echo "SUCCESS - Version: ${3}."
fi

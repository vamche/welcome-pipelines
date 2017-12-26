#!/bin/bash
set -e

git config user.email "pipelines-cd@no-emails.com"
git config user.name "Pipelines CD"
git fetch --all
git checkout master
node $SOURCE_DIR/test.js

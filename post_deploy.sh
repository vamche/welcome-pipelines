#!/bin/bash
set -e

git config user.email "pipelines-cd@no-emails.com"
git config user.name "Pipelines CD"
node $SOURCE_DIR/test.js

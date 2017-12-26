#!/bin/bash
set -e

git config user.email "pipelines-cd@no-emails.com"
git config user.name "Pipelines CD"

git add .
git commit -m 'test!'

node $SOURCE_DIR/test.js

#!/bin/bash
set -e

# Get Authentication token
TOKEN=$(curl -sS -X POST -u "${CLOUD_API_KEY}:${CLOUD_API_SECRET}" -d "grant_type=client_credentials" https://accounts.acquia.com/api/auth/oauth/token | python -c "import sys, json; print json.load(sys.stdin)['access_token']")

# Get CDE Name
CDE_NAME=$(cat $PIPELINES_SCRIPT_DATA_FILE | python -c "import sys, json; print json.load(sys.stdin)['environment']['PIPELINES_DEPLOYMENT_NAME']")

# Get CDE id
ENV_ID=$(curl -sS -X GET "https://cloud.acquia.com/api/applications/$PIPELINE_APPLICATION_ID/environments" -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" | python -c "import sys, json; envs=json.load(sys.stdin)['_embedded']['items']; print [x for x in envs if x['label'] == '$CDE_NAME'][0]['id']")

echo $ENV_ID

#!/bin/bash
set -e

# Get Cloud Authentication token.
TOKEN=$(curl -sS -X POST -u "${CLOUD_API_KEY}:${CLOUD_API_SECRET}" -d "grant_type=client_credentials" https://accounts.acquia.com/api/auth/oauth/token | python -c "import sys, json; print json.load(sys.stdin)['access_token']")

# Get CDE Name created by the Pipelines Job.
CDE_NAME=$(cat $PIPELINES_SCRIPT_DATA_FILE | python -c "import sys, json; print json.load(sys.stdin)['environment']['PIPELINES_DEPLOYMENT_NAME']")

# Get target environment Id using the CDE name.
ENV_ID=$(curl -sS -X GET "https://cloud.acquia.com/api/applications/$PIPELINE_APPLICATION_ID/environments" -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" | python -c "import sys, json; envs=json.load(sys.stdin)['_embedded']['items']; print [x for x in envs if x['name'] == '$CDE_NAME'][0]['id']")

# Get Source (i.e, Stage in this example) environment Id.
STAGE_ENV_ID=$(curl -sS -X GET "https://cloud.acquia.com/api/applications/$PIPELINE_APPLICATION_ID/environments" -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" | python -c "import sys, json; envs=json.load(sys.stdin)['_embedded']['items']; print [x for x in envs if x['name'] == 'test'][0]['id']")

# Copy Files from CDE to Source envronment to target. Use the notification url returned to get the tasks's status.
NOTIFICATION_LINK=$(curl -sS -X POST -d "{\"source\":\"$STAGE_ENV_ID\"}" "https://cloud.acquia.com/api/environments/$ENV_ID/files" -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" | python -c "import sys, json; print json.load(sys.stdin)['_links']['notification']['href']")
# curl -v -X POST "https://cloud.acquia.com/api/environments/$ENV_ID/files" -d "{\"source\":\"$STAGE_ENV_ID\"}" -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}"

# Wait for 'Copy Files' task to finish.
# Poll NOTIFICATION_LINK to know the status
COPY_STATUS='in-progress'

while [ $COPY_STATUS == 'in-progress' ]; do
  sleep 10;
  COPY_STATUS=$(curl -sS -X GET $NOTIFICATION_LINK -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" | python -c "import sys, json; print json.load(sys.stdin)['status']");
  echo $COPY_STATUS;
done

# Exit with 1 if the final status is 'failed'. Do nothing if the final status is 'completed' which mean the files copied successfully.
if [ $COPY_STATUS == 'failed' ]
then
  echo 'Failed to copy the files!'
  exit 1
fi

#!/bin/bash
set -euo pipefail

#
# Commands
#

GCLOUD="${GCLOUD:-gcloud}"
JQ="${JQ:-jq}"
NI="${NI:-ni}"
RM_F="${RM_F:-rm -f}"

#
# Variables
#

WORKDIR="${WORKDIR:-/workspace}"

#
#
#

log() {
  echo "[$( date -Iseconds )] $@"
}

err() {
  log "error: $@" >&2
  exit 2
}

usage() {
  echo "usage: $@" >&2
  exit 1
}

$NI credentials config -d "${WORKDIR}/creds"

[ -f "${WORKDIR}/creds/service-account.json" ] || usage "spec: specify \`credentials.'service-account.json'\`, the service account to use for Google Cloud"

$GCLOUD config set core/disable_usage_reporting true
$GCLOUD config set component_manager/disable_update_check true

$GCLOUD auth activate-service-account --key-file="${WORKDIR}/creds/service-account.json"

$RM_F "${WORKDIR}/creds/service-account.json"

SERVICE="$( $NI get -p '{ .service }' )"
[ -z "${SERVICE}" ] && usage "spec: specify \`service\`, the name of the Cloud Run service to deploy to"

declare -a DEPLOY_ARGS

PROJECT="$( $NI get -p '{ .project }' )"
[ -z "${PROJECT}" ] && usage "spec: specify \`project\`, the identifier for the Google Cloud project to deploy to"
DEPLOY_ARGS+=( "--project=${PROJECT}" )

DEPLOY_ARGS+=( "--platform=managed" )

IMAGE_REPOSITORY="$( $NI get -p '{ .image.repository }' )"
[ -z "${IMAGE_REPOSITORY}" ] && usage "spec: specify \`image.repository\`, the repository of the Docker image to deploy"

IMAGE_TAG="$( $NI get -p '{ .image.tag }' )"
[ -z "${IMAGE_TAG}" ] && IMAGE_TAG=latest

DEPLOY_ARGS+=( "--image=${IMAGE_REPOSITORY}:${IMAGE_TAG}" )

REGION="$( $NI get -p '{ .region }' )"
[ -z "${REGION}" ] && usage "spec: specify \`region\`, the Google Cloud region to deploy this service to"
DEPLOY_ARGS+=( "--region=${REGION}" )

ARGS="$( $NI get | $JQ -r 'try .args | join(",")' )"
DEPLOY_ARGS+=( "--args=${ARGS}" )

COMMAND="$( $NI get -p '{ .command }' )"
DEPLOY_ARGS+=( "--command=${COMMAND}" )

CONCURRENCY="$( $NI get -p '{ .concurrency }' )"
[ -z "${CONCURRENCY}" ] && CONCURRENCY=default
DEPLOY_ARGS+=( "--concurrency=${CONCURRENCY}" )

MAX_INSTANCES="$( $NI get -p '{ .maxInstances }' )"
[ -z "${MAX_INSTANCES}" ] && MAX_INSTANCES=default
DEPLOY_ARGS+=( "--max-instances=${MAX_INSTANCES}" )

PORT="$( $NI get -p '{ .port }' )"
[ -z "${PORT}" ] && PORT=default
DEPLOY_ARGS+=( "--port=${PORT}" )

ENV="$( $NI get | $JQ -r 'try .env | to_entries | map("\( .key )=\( .value )") | join(",")' )"
DEPLOY_ARGS+=( "--set-env-vars=${ENV}" )

DEPLOY_ARGS+=( "--clear-labels" )

LABELS="$( $NI get | $JQ -r 'try .labels | to_entries | map("\( .key )=\( .value )") | join(",")' )"
DEPLOY_ARGS+=( "--update-labels=${LABELS}" )

ALLOW_UNAUTHENTICATED="$( $NI get -p '{ .allowUnauthenticated }' )"
if [ "${ALLOW_UNAUTHENTICATED,,}" != "true" ]; then
  DEPLOY_ARGS+=( "--no-allow-unauthenticated" )
else
  DEPLOY_ARGS+=( "--allow-unauthenticated" )
fi

REVISION_SUFFIX="$( $NI get -p '{ .revisionSuffix }' )"
[ -n "${REVISION_SUFFIX}" ] && DEPLOY_ARGS+=( "--revision-suffix=${REVISION_SUFFIX}" )

SERVICE_ACCOUNT="$( $NI get -p '{ .serviceAccount.email }' )"
[ -n "${SERVICE_ACCOUNT}" ] && DEPLOY_ARGS+=( "--service-account=${SERVICE_ACCOUNT}" )

$GCLOUD run deploy "${SERVICE}" "${DEPLOY_ARGS[@]}"

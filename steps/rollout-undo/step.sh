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
# Functions
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

#
# Setup
#

$NI credentials config -d "${WORKDIR}/creds"

[ -f "${WORKDIR}/creds/service-account.json" ] || usage "spec: specify \`credentials.'service-account.json'\`, the service account to use for Google Cloud"

$GCLOUD config set core/disable_usage_reporting true
$GCLOUD config set component_manager/disable_update_check true

$GCLOUD auth activate-service-account --key-file="${WORKDIR}/creds/service-account.json"

$RM_F "${WORKDIR}/creds/service-account.json"

#
# Actions
#

DEPLOYMENT="$( $NI get -p '{ .deployment }' )"
[ -z "${DEPLOYMENT}" ] && usage "spec: specify \`incidentService\`, the name of the deployment to manage"

NAMESPACE="$( $NI get -p '{ .namespace }' )"
[ -z "${NAMESPACE}" ] && usage "spec: specify \`incidentEnvironment\`, the namespace in which the deployment is running"

kubectl rollout undo deployment.v1.apps/${DEPLOYMENT} --namespace=${NAMESPACE}

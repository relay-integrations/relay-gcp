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

$NI gcp config -d "${WORKDIR}/creds"

[ -f "${WORKDIR}/creds/credentials.json" ] || usage "spec: specify a gcp connection as \`google: \!Connection ...\` in your spec"

PROJECT=$(jq -r .project_id ${WORKDIR}/creds/credentials.json)

$GCLOUD config set project ${PROJECT}

$GCLOUD config set core/disable_usage_reporting true
$GCLOUD config set component_manager/disable_update_check true

$GCLOUD auth activate-service-account --key-file="${WORKDIR}/creds/credentials.json"

$RM_F "${WORKDIR}/creds/credentials.json"

#
# Actions
#

DEPLOYMENT="$( $NI get -p '{ .deployment }' )"
[ -z "${DEPLOYMENT}" ] && usage "spec: specify \`incidentService\`, the name of the deployment to manage"

NAMESPACE="$( $NI get -p '{ .namespace }' )"
[ -z "${NAMESPACE}" ] && usage "spec: specify \`incidentEnvironment\`, the namespace in which the deployment is running"

CLUSTER="$( $NI get -p '{ .cluster }' )"
[ -z "${CLUSTER}" ] && usage "spec: specify \`cluster\`, the cluster name where deployment is running"

ZONE="$( $NI get -p '{ .zone }' )"
[ -z "${ZONE}" ] && usage "spec: specify \`zone\`, the zone where the cluster is running"

# generate a kubeconfig
$GCLOUD container clusters get-credentials $CLUSTER --zone $ZONE

kubectl rollout undo deployment.v1.apps/${DEPLOYMENT} --namespace=${NAMESPACE}

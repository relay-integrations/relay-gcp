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

[ -f "${WORKDIR}/creds/credentials.json" ] || usage "spec: specify a gcp connection as \`google: connection: \!Connection ...\` in your spec"

PROJECT=$(jq -r .project_id ${WORKDIR}/creds/credentials.json)

$GCLOUD config set project ${PROJECT}

$GCLOUD config set core/disable_usage_reporting true
$GCLOUD config set component_manager/disable_update_check true

$GCLOUD auth activate-service-account --key-file="${WORKDIR}/creds/credentials.json"

$RM_F "${WORKDIR}/creds/credentials.json"

#
# Actions
#

COMMAND=$( $NI get -p '{.command}')
FILE=
if [ "${COMMAND}" == "apply" ]; then
    ARGS="-f"
    FILE=$( $NI get -p '{.file}')
else
    ARGS=$( $NI get -p '{.args}')
fi

NAMESPACE="$( $NI get -p '{ .google.namespace }' )"
[ -z "${NAMESPACE}" ] && usage "spec: specify \`google.namespace\`, the namespace to operate on"

CLUSTER="$( $NI get -p '{ .google.name }' )"
[ -z "${CLUSTER}" ] && usage "spec: specify \`google.name\`, the cluster name to operate on"

ZONE="$( $NI get -p '{ .google.zone }' )"
[ -z "${ZONE}" ] && usage "spec: specify \`google.zone\`, the zone where the cluster is running"

# generate a kubeconfig
$GCLOUD container clusters get-credentials $CLUSTER --zone $ZONE

FILE_PATH=${FILE}

GIT=$(ni get -p {.git})
if [ -n "${GIT}" ]; then
    ni git clone
    NAME=$(ni get -p {.git.name})
    FILE_PATH=/workspace/${NAME}/${FILE}
fi

echo "Running command: kubectl ${COMMAND} ${ARGS} ${FILE_PATH} --namespace ${NS}"


RESULT=$(kubectl ${COMMAND} ${ARGS} ${FILE_PATH} --namespace ${NS})
echo $RESULT

$NI output set -k result -v "${RESULT}"

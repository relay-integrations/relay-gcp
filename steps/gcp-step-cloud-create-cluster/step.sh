#!/bin/bash
set -euo pipefail

#
# Commands
#

GCLOUD="${GCLOUD:-gcloud}"
KUBECTL="${KUBECTL:-kubectl}"
JQ="${JQ:-jq}"
NI="${NI:-ni}"

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

[ -f "${WORKDIR}/creds/service-account.json" ] || usage "spec: specify \`credentials.'service-account.json'\`"

$GCLOUD auth activate-service-account --key-file="${WORKDIR}/creds/service-account.json"

PROJECT="$( $NI get -p '{ .project }' )"
[ -z "${PROJECT}" ] && usage "spec: specify \`project\`"

$GCLOUD config set project ${PROJECT}

CLUSTER="$( $NI get -p '{ .cluster }' )"
[ -z "${CLUSTER}" ] && usage "spec: specify \`cluster\`"

declare -a LOCALITY_ARGS

NODE_TYPE="$( $NI get -p '{ .nodes.type }' )"
[ -z "${NODE_TYPE}" ] && usage "spec: specify \`node.type\`"

CREATE_CLUSTER_ARGS+=( "--machine-type=${NODE_TYPE}" )

NODE_COUNT="$( $NI get -p '{ .nodes.count }' )"
[ -z "${NODE_COUNT}" ] && usage "spec: specify \`node.count\`"

CREATE_CLUSTER_ARGS+=( "--num-nodes=${NODE_COUNT}" )

ZONE="$( $NI get -p '{ .zone }' )"
[ -n "${ZONE}" ] && LOCALITY_ARGS+=( "--zone=${ZONE}" )

REGION="$( $NI get -p '{ .region }' )"
[ -z "${ZONE}" ] && [ -n "${REGION}" ] && LOCALITY_ARGS+=( "--region=${REGION}" )

$GCLOUD container clusters create "${CLUSTER}" "${CREATE_CLUSTER_ARGS[@]}" "${LOCALITY_ARGS[@]}"

$GCLOUD container clusters get-credentials "${CLUSTER}" "${LOCALITY_ARGS[@]}"

$GCLOUD components install kubectl

$KUBECTL create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$($GCLOUD config get-value core/account);

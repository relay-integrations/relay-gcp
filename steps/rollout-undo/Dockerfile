FROM google/cloud-sdk:alpine
RUN apk --no-cache add bash ca-certificates curl git jq openssh && update-ca-certificates
RUN gcloud components install kubectl
COPY "./step.sh" "/step.sh"
ENTRYPOINT []
CMD ["/bin/bash", "/step.sh"]

LABEL "org.opencontainers.image.title"="Undo a deployment rollout"
LABEL "org.opencontainers.image.description"="This step rolls back to a previous version of a Deployment"
LABEL "com.puppet.nebula.sdk.version"="v1"

FROM google/cloud-sdk:alpine
RUN apk --no-cache add bash ca-certificates curl git jq openssh && update-ca-certificates
COPY "./step.sh" "/step.sh"
ENTRYPOINT []
CMD ["/bin/bash", "/step.sh"]

LABEL "org.opencontainers.image.title"="Deploy a revision to Google Cloud Run"
LABEL "org.opencontainers.image.description"="This step deploys a new revision to a Google Cloud Run service."
LABEL "com.puppet.nebula.sdk.version"="v1"

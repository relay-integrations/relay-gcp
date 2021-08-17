FROM google/cloud-sdk:alpine
RUN set -eux ; \
    mkdir -p /tmp/ni && \
    cd /tmp/ni && \
    wget https://packages.nebula.puppet.net/sdk/ni/v1/ni-v1-linux-amd64.tar.xz && \
    wget https://packages.nebula.puppet.net/sdk/ni/v1/ni-v1-linux-amd64.tar.xz.sha256 && \
    echo "$( cat ni-v1-linux-amd64.tar.xz.sha256 )  ni-v1-linux-amd64.tar.xz" | sha256sum -c - && \
    tar -xvJf ni-v1-linux-amd64.tar.xz && \
    mv ni-v1*-linux-amd64 /usr/local/bin/ni && \
    cd - && \
    rm -fr /tmp/ni
RUN apk --no-cache add bash ca-certificates curl git jq openssh && update-ca-certificates
COPY "./step.sh" "/step.sh"
ENTRYPOINT []
CMD ["/bin/bash", "/step.sh"]

LABEL "org.opencontainers.image.title"="Deploy a revision to Google Cloud Run"
LABEL "org.opencontainers.image.description"="This step deploys a new revision to a Google Cloud Run service."
LABEL "com.puppet.nebula.sdk.version"="v1"

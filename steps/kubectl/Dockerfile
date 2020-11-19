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
RUN gcloud components install kubectl
COPY "./step.sh" "/kubectl.sh"
ENTRYPOINT []
CMD ["/bin/bash", "/kubectl.sh"]

LABEL "org.opencontainers.image.title"="Run aribitrary kubectl commands against a gcp cluster"
LABEL "org.opencontainers.image.description"="This will run kubectl commands with specified arguments against a configured GCP cluster."
LABEL "com.puppet.nebula.sdk.version"="v1"

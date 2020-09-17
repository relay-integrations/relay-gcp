# gcp-step-cloud-run-deploy

This [Google Cloud Run](https://cloud.google.com/run) step container deploys a
new revision of a service to the managed Cloud Run environment.

For more information on acquiring the `service account` key, see the [reference documentation](https://cloud.google.com/run/docs/reference/iam/roles#additional-configuration) for the required permissions.

> **Note**: The value you set for a secret must be a string. If you have
> multiple key-value pairs to pass into the secret, or your secret is the
> contents of a file, you must encode the values using base64 encoding, and use
> the encoded string as the secret value.

## Limitations

This step does not currently support the Anthos or VMWare Cloud Run platforms.

## Example

```yaml
steps:
# ...
- name: gcp-cloud-run-deploy
  image: relaysh/gcp-step-cloud-run-deploy
  spec:
    credentials:
      service-account.json:
        $type: Secret
        name: service-account-base64
    project: nebula-contrib
    service: my-test-service
    region: us-central1
    image:
      repository: gcr.io/cloudrun/hello
      tag: latest
    concurrency: 10
    maxInstances: 10
    env:
      MY_ENV_VAR: MY_ENV_VALUE
    labels:
      environment: production
    allowUnauthenticated: true
    serviceAccount:
      email: my-custom-sa@cloudrun.iam.gserviceaccount.com
```

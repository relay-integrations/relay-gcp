# gcp-cloud-run-deploy

This [Google Cloud Run](https://cloud.google.com/run) step container deploys a
new revision of a service to the managed Cloud Run environment.

## Specifications

| Setting | Child setting | Data type | Description | Default | Required |
|---------|---------------|-----------|-------------|---------|----------|
| `credentials` || mapping | Credentials to use when running this step. | None | True |
|| `service-account.json` | string | A base64-encoded JSON service account key to use for deploying the revision. See the [reference documentation](https://cloud.google.com/run/docs/reference/iam/roles#additional-configuration) for the required permissions. | None | True |
| `project` || string | The identifier of the Google Cloud project to deploy to. | None | True |
| `service` || string | The name of the service to deploy to. | None | True |
| `region` || string | The region to deploy to. | None | True |
| `image` || mapping | The Docker image to deploy. | None | True |
|| `repository` | string | The name of the repository containing the Docker image. | None | True |
|| `tag` | string | The tag to deploy. | `latest` | False |
| `serviceAccount` || mapping | The service account to use when executing the service. | Project default | False |
|| `email` | string | The email address of the service account. | None | False |
| `command` || string | The command to execute in the container. | Specified by the container | False |
| `args` || list | A list of arguments to provide to the command. | Specified by the container | False |
| `concurrency` || integer | The number of requests a single instance of the service can respond to simultaneously. | Dynamic | False |
| `maxInstances` || integer | The maximum number of instances that can be running at once. | 1000 | False |
| `port` || integer | The container port to forward requests to. | Dynamic | False |
| `env` || mapping | A YAML key-value mapping of environment variables to provide to each container. | None | False |
| `labels` || mapping | A YAML key-value mapping of labels to add to the revision. | None | False |
| `allowUnauthenticated` || boolean | Whether to allow anonymous access to the service. | `false` | False |
| `revisionSuffix` || string | The revision identifier to use, appended to the service name. | Automatically generated | False |

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
  image: projectnebula/gcp-cloud-run-deploy
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

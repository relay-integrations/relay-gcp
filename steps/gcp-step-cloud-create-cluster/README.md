# gcp-step-cloud-create-cluster

This [Google Cloud Run](https://cloud.google.com/run) step container deploys a
new revision of a service to the managed Cloud Run environment.

## Specifications

| Setting | Child setting | Data type | Description | Default | Required |
|---------|---------------|-----------|-------------|---------|----------|
| `credentials` || mapping | Credentials to use when running this step. | None | True |
|| `service-account.json` | string | A base64-encoded JSON service account key to use for deploying the revision. See the [reference documentation](https://cloud.google.com/run/docs/reference/iam/roles#additional-configuration) for the required permissions. | None | True |
| `cluster` || string | The cluster name to create. | None | True |
| `project` || string | The identifier of the Google Cloud project to create the cluster in. | None | True |
| `region` || string | The region to create the cluster in. | None | False |
| `zone` || string | The zone to create the cluster in. | None | False |
| `nodes` || mapping | Node details. | None | False |
|| `count` | int | Count of nodes | None | False |
|| `type` | string | Type of nodex | None | False |

> **Note**: The value you set for a secret must be a string. If you have
> multiple key-value pairs to pass into the secret, or your secret is the
> contents of a file, you must encode the values using base64 encoding, and use
> the encoded string as the secret value.

## Example

```yaml
steps:
- name: gcp-cloud-create-cluster
  image: relaysh/gcp-step-cloud-create-cluster
  spec:
    credentials:
      service-account.json: !Secret service-account-base64
    cluster: my-cluster
    project: nebula-contrib
    region: us-west2
    nodes:
      count: 1
      type: n2-standard-2
```

# gcp-step-instance-list

This GCP step container describes a set of instances and their metadata.

## Specification 

| Setting | Child setting | Data type | Description | Default | Required |
|---------|---------------|-----------|-------------|---------|----------|
| `google` || mapping | A mapping of GCP account configuration. | None | True |
|| `service_account_info` | GCP Connection | Relay Connection for the GCP account. Use the Connection sidebar to configure the Connection | None | True |
|| `zone` | string | The GCP zone to use (for example, `us-central1-a`). | None | True |

## Example 

```yaml
- name: list-instances
  image: relaysh/gcp-step-instance-list
  spec:
    google: &google
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-centra1-a
```

## Example output `instances`

```
[
    {
        "id":"3900850146904586699",
        "kind":"compute#instance",
        "fingerprint":"14ejPjxPT7A=",
        "labelFingerprint":"42WmSpB8rSM=",
        "creationTimestamp":"2020-06-17T14:12:04.484-07:00",
        "deletionProtection":False,
        "description":"",
        "name":"instance-1",
        "metadata":{
            "fingerprint":"jucTflKX3gU=",
            "kind":"compute#metadata"
        },
        "selfLink":"https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instances/instance-1",
        "status":"TERMINATED",
        "tags":{
            "fingerprint":"42WmSpB8rSM="
        },
        "zone":"https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a",
        "machineType":"https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/machineTypes/g1-small"
    }
]

```
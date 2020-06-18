# gcp-step-instance-stop

This GCP step container stops a given set of instances. For more information, check out [GCP documentation here](https://cloud.google.com/compute/docs/reference/rest/v1/instances/stop).

## Specification 

| Setting | Child setting | Data type | Description | Default | Required |
|---------|---------------|-----------|-------------|---------|----------|
| `google` || mapping | A mapping of GCP account configuration. | None | True |
|| `service_account_info` | GCP Connection | Relay Connection for the GCP account. Use the Connection sidebar to configure the Connection | None | True |
|| `zone` | string | The GCP zone to use (for example, `us-central1-a`). | None | True |
| `instances` || array of strings | The list of instances to stop. See examples below. | None | True |

## Example: List of instances

```yaml
- name: stop-instances
  image: relaysh/gcp-step-instance-stop	
  spec:
    google:
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-central1-a
    instances: 
    - instance-1
    - instance-2
```

## Example: Output from previous step

```yaml
- name: stop-instances
  image: relaysh/gcp-step-instance-stop	
  spec:
    google:
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-central1-a
    instances: !Output { from: list-instances, name: instances }
```
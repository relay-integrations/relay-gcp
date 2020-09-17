# gcp-step-instance-reset

This GCP step container resets a given set of instances. For more information, check out [GCP documentation here](https://cloud.google.com/compute/docs/reference/rest/v1/instances/reset).

## Example: List of instances

```yaml
- name: reset-instances
  image: relaysh/gcp-step-instance-reset	
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
- name: reset-instances
  image: relaysh/gcp-step-instance-reset	
  spec:
    google:
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-central1-a
    instances: !Output { from: list-instances, name: instances }
```
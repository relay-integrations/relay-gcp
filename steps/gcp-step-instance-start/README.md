# gcp-step-instance-start

This GCP step container starts a given set of instances. For more information, check out [GCP documentation here](https://cloud.google.com/compute/docs/reference/rest/v1/instances/start).

## Example: List of instances

```yaml
- name: start-instances
  image: relaysh/gcp-step-instance-start	
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
- name: start-instances
  image: relaysh/gcp-step-instance-start	
  spec:
    google:
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-central1-a
    instances: !Output { from: list-instances, name: instances }
```
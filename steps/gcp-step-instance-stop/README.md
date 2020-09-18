# gcp-step-instance-stop

This GCP step container stops a given set of instances. For more information, check out [GCP documentation here](https://cloud.google.com/compute/docs/reference/rest/v1/instances/stop).

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
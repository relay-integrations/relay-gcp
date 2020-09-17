# gcp-step-disk-delete

This GCP step container terminates a given set of disks. For more information, check out [GCP documentation here](https://cloud.google.com/compute/docs/reference/rest/v1/disks/delete).

## Example: List of disks

```yaml
- name: delete-disks
  image: relaysh/gcp-step-disk-delete	
  spec:
    google:
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-central1-a
    disks: 
    - disk-1
    - disk-2
```

## Example: Using output from previous step

```yaml
- name: delete-disks
  image: relaysh/gcp-step-disk-delete	
  spec:
    google:
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-central1-a
    disks: !Output { from: list-disks, name: disks }
```
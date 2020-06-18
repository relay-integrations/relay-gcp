# gcp-step-disk-delete

This GCP step container terminates a given set of disks. For more information, check out [GCP documentation here](https://cloud.google.com/compute/docs/reference/rest/v1/disks/delete).

## Specification 

| Setting | Child setting | Data type | Description | Default | Required |
|---------|---------------|-----------|-------------|---------|----------|
| `google` || mapping | A mapping of GCP account configuration. | None | True |
|| `service_account_info` | GCP Connection | Relay Connection for the GCP account. Use the Connection sidebar to configure the Connection | None | True |
|| `zone` | string | The GCP zone to use (for example, `us-central1-a`). | None | True |
| `disks` || array of strings | The list of disks to delete. See examples below. | None | True |

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

## Example: Output from previous step

```yaml
- name: delete-disks
  image: relaysh/gcp-step-disk-delete	
  spec:
    google:
      service_account_info: !Connection { type: gcp, name: my-gcp-account }
      zone: us-central1-a
    disks: !Output { from: list-disks, name: disks }
```
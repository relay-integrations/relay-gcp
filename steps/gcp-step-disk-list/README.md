# gcp-step-disk-list

This GCP step container describes a set of disks and their metadata.

## Example output `disks`

```
[
   {
      "id":"5091177466620570237",
      "kind":"compute#disk",
      "labelFingerprint":"42WzlSpq9zWQ=",
      "description":"my-disk-1",
      "creationTimestamp":"2019-05-01T10:17:06.713-07:00",
      "sizeGb":"10",
      "name":"disk-1",
      "selfLink":"https://www.googleapis.com/compute/v1/projects/kenazk-sandbox/zones/us-central1-a/disks/disk-1",
      "status":"READY",
      "zone":"https://www.googleapis.com/compute/v1/projects/kenazk-sandbox/zones/us-central1-a"
   },
   {
      "id":"166038021897218685",
      "kind":"compute#disk",
      "labelFingerprint":"42WmSpB8rSM=",
      "description":"my-disk-2",
      "creationTimestamp":"2019-05-01T10:17:07.378-07:00",
      "sizeGb":"8",
      "users":[
         "https://www.googleapis.com/compute/v1/projects/kenazk-sandbox/zones/us-central1-a/instances/instance-1"
      ],
      "name":"disk-2",
      "selfLink":"https://www.googleapis.com/compute/v1/projects/kenazk-sandbox/zones/us-central1-a/disks/disk-2",
      "status":"READY",
      "zone":"https://www.googleapis.com/compute/v1/projects/kenazk-sandbox/zones/us-central1-a"
   },
   {
      "id":"4942773577605999229",
      "kind":"compute#disk",
      "labelFingerprint":"42WmSpB8rSM=",
      "description":"my-disk-3",
      "creationTimestamp":"2019-05-01T10:17:07.768-07:00",
      "sizeGb":"10",
      "name":"disk-3",
      "selfLink":"https://www.googleapis.com/compute/v1/projects/kenazk-sandbox/zones/us-central1-a/disks/disk-3",
      "status":"READY",
      "zone":"https://www.googleapis.com/compute/v1/projects/kenazk-sandbox/zones/us-central1-a"
   }
]
```
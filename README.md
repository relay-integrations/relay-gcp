# GCP integration

Integration with Google for Puppet Relay.

## Steps

The following steps are available in this integration:

| Name | Description |
|------|-------------|
| [gcp-step-cloud-run-deploy](/steps/gcp-step-cloud-run-deploy) | Deploy cloud run service revision |
| [gcp-step-instance-delete](/steps/gcp-step-instance-delete) | Delete GCP instances |
| [gcp-step-instance-list](/steps/gcp-step-instance-list) | List GCP instances |
| [gcp-step-instance-start](/steps/gcp-step-instance-start) | Start GCP instances |
| [gcp-step-instance-stop](/steps/gcp-step-instance-stop) | Stops GCP instances |
| [gcp-step-instance-suspend](/steps/gcp-step-instance-suspend) | Suspends GCP instances |
| [gcp-step-instance-reset](/steps/gcp-step-instance-reset) | Resets GCP instances |
| [gcp-step-disk-delete](/steps/gcp-step-disk-delete) | Delete GCP disks |
| [gcp-step-disk-list](/steps/gcp-step-disk-list) | List GCP disks |
| [rollout-undo](/steps/rollout-undo) | Roll back a GKE Deployment on a cluster |


## Contributing

### Issues

Feel free to submit issues and enhancement requests.

### Contributing

In general, we follow the "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

### Development

The python steps in this repository require Python 3. It's recommended you
setup a virtualenv with the relevant depedencies in it for running the python
steps yourself.

```bash
virtualenv .virtualenv
source .virtualenv/bin/activate
.virtualenv/bin/pip install google-api-python-client
.virtualenv/bin/pip --no-cache-dir install relay_sdk
```

### License

As indicated by the repository, this project is licensed under Apache 2.0.

# GCP integration

Integration with Google for Puppet Relay.

## Steps

The following steps are available in this integration:

| Name | Description |
|------|-------------|
| [cloud-run-deploy](/steps/cloud-run-deploy) | Deploy cloud run service revision |
| [instance-delete](/steps/instance-delete) | Delete GCP instances |
| [instance-list](/steps/instance-list) | List GCP instances |
| [instance-start](/steps/instance-start) | Start GCP instances |
| [instance-stop](/steps/instance-stop) | Stops GCP instances |
| [instance-suspend](/steps/instance-suspend) | Suspends GCP instances |
| [instance-reset](/steps/instance-reset) | Resets GCP instances |
| [instance-resume](/steps/instance-resume) | Resumes GCP instances |
| [disk-delete](/steps/disk-delete) | Delete GCP disks |
| [disk-list](/steps/disk-list) | List GCP disks |
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

The python steps in this repository require Python 3.

```bash
pip3 install google-api-python-client
pip3 --no-cache-dir install relay_sdk
```

### License

This project is [licensed](LICENSE) under Apache 2.0.

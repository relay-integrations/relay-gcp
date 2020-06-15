# Google integration

Integration with Google for Puppet Relay.

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
.virtualenv/bin/pip --no-cache-dir install "https://packages.nebula.puppet.net/sdk/support/python/v1/nebula_sdk-1-py3-none-any.whl"
```

### License

As indicated by the repository, this project is licensed under Apache 2.0.

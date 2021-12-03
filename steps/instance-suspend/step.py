import googleapiclient.discovery

from google.oauth2 import service_account
from relay_sdk import Interface, Dynamic as D
import json

def slice(orig, keys):
    return {key: orig[key] for key in keys if key in orig}

def do_suspend_instance(compute, project_id, zone, name):
    print('suspending instance {0}'.format(name))
    try:
        result = compute.instances().suspend(project=project_id, zone=zone, instance=name).execute()
        return result['items'] if 'items' in result else []
    except Exception as e:
        print('GCP instance {0} failed to suspend. Shutting down. Exception: {1}'.format(name, e))
        result = compute.instances().stop(project=project_id, zone=zone, instance=name).execute()
        return result['items'] if 'items' in result else []

def suspend_instances(instances):
    # For security purposes we whitelist the keys that can be fed in to the
    # google oauth library. This prevents workflow users from feeding arbitrary
    # data in to that library.
    service_account_info_keys = [
        "type",
        "project_id",
        "private_key_id",
        "private_key",
        "client_email",
        "client_id",
        "auth_uri",
        "token_uri",
        "auth_provider_x509_cert_url",
        "client_x509_cert_url",
    ]

    zone = relay.get(D.google.zone)

    if not zone:
        print("Missing `google.zone` parameter on step configuration.")
        exit(1)

    # TODO: How to validate all the required data is present here?
    service_account_info=slice(json.loads(relay.get(D.google.service_account_info)['serviceAccountKey']), service_account_info_keys)

    credentials = service_account.Credentials.from_service_account_info(service_account_info)
    compute = googleapiclient.discovery.build("compute", "beta", credentials=credentials)

    for instance in instances:
        if isinstance(instance, dict):
            do_suspend_instance(compute, project_id=credentials.project_id, zone=zone, name=instance["name"])
        else:
            do_suspend_instance(compute, project_id=credentials.project_id, zone=zone, name=instance)

if __name__ == "__main__":
    relay = Interface()
    suspend_instances(relay.get(D.instances))
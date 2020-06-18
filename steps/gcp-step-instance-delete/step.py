import googleapiclient.discovery

from google.oauth2 import service_account
from nebula_sdk import Interface, Dynamic as D
import json

def slice(orig, keys):
    return {key: orig[key] for key in keys if key in orig}

def do_delete_instance(compute, project_id, zone, name):
    print('Deleting instance {0}'.format(name))
    result = compute.instances().delete(project=project_id, zone=zone, instance=name).execute()
    return result['items'] if 'items' in result else []

def delete_instances(instances):
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
    compute = googleapiclient.discovery.build("compute", "v1", credentials=credentials)

    for instance in instances:
        if isinstance(instance, dict):
            do_delete_instance(compute, project_id=credentials.project_id, zone=zone, name=instance["name"])
        else: 
            do_delete_instance(compute, project_id=credentials.project_id, zone=zone, name=instance)

if __name__ == "__main__":
    relay = Interface()
    delete_instances(relay.get(D.instances))

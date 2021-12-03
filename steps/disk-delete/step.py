import googleapiclient.discovery

from google.oauth2 import service_account
from relay_sdk import Interface, Dynamic as D
import json

def slice(orig, keys):
    return {key: orig[key] for key in keys if key in orig}

def do_delete_disk(compute, project_id, zone, name):
    print('Deleting disk {0}'.format(name))
    result = compute.disks().delete(project=project_id, zone=zone, disk=name).execute()
    return result['items'] if 'items' in result else []

def delete_disks(disks):
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

    for disk in disks:
        if isinstance(disk, dict):
            do_delete_disk(compute, project_id=credentials.project_id, zone=zone, name=disk["name"])
        else: 
            do_delete_disk(compute, project_id=credentials.project_id, zone=zone, name=disk)

if __name__ == "__main__":
    relay = Interface()
    delete_disks(relay.get(D.disks))

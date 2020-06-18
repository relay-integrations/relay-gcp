import googleapiclient.discovery

from google.oauth2 import service_account
from nebula_sdk import Interface, Dynamic as D
import json

def slice(orig, keys):
    return {key: orig[key] for key in keys if key in orig}

def slice_arr(orig, keys):
    return [slice(obj, keys) for obj in orig]

def do_list_disks(compute, project_id, zone):
    result = compute.disks().list(project=project_id, zone=zone).execute()
    return result['items'] if 'items' in result else []

def list_disks():
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
    compute = googleapiclient.discovery.build('compute', 'v1', credentials=credentials)

    disks = do_list_disks(compute, credentials.project_id, zone=zone)

    # These are the keys that we're going to cherry-pick out of the result.
    # We're explicit about the keys that we want to publish for documentation
    # purposes.
    disk_keys = [
	"id",
	"kind",
	"labelFingerprint",
	"labels",
	"description",
	"creationTimestamp",
	"sizeGb",
	"users",
	"name",
	"selfLink",
	"status",
	"zone",
    "sourceSnapshot",
    "sourceSnapshotId",
    "options"
    "type"
    ]

    return slice_arr(disks, disk_keys)

if __name__ == "__main__":
    relay = Interface()
    disks = list_disks()
    if (len(disks) == 0):
        print('No disks found! Exiting.')
        exit(1)
    print("Found the following disks:\n")
    print("{:<80} {:<30} {:<30}".format('NAME', 'STATUS', 'SIZEGB'))
    for disk in disks: 
        print("{:<80} {:<30} {:<30}".format(disk['name'], disk['status'], disk['sizeGb']))
    print('\nAdding {0} disk(s) to the output `disks`'.format(len(disks)))
    relay.outputs.set("disks", disks)
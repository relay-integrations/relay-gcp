import googleapiclient.discovery

from google.oauth2 import service_account
from nebula_sdk import Interface, Dynamic as D

def slice(orig, keys):
    return {key: orig[key] for key in keys if key in orig}

def slice_arr(orig, keys):
    return [slice(obj, keys) for obj in orig]

def do_list_instances(compute, project_id, zone):
    result = compute.instances().list(project=project_id, zone=zone).execute()
    return result['items'] if 'items' in result else []

def list_instances():
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

    zone = D.google.zone

    if not zone:
        print("Missing `google.zone` parameter on step configuration.")
        exit(1)

    # TODO: How to validate all the required data is present here?
    service_account_info = slice(D.google.service_account_info, service_account_info_keys)

    credentials = service_account.Credentials.from_service_account_info(D.google.service_account_info)
    compute = googleapiclient.discovery.build('compute', 'v1', credentials=credentials)

    instances = do_list_instances(compute, credentials.project_id, zone=zone)

    # These are the keys that we're going to cherry-pick out of the result.
    # We're explicit about the keys that we want to publish for documentation
    # purposes.
    instance_keys = [
	"id",
	"kind",
	"fingerprint",
	"labelFingerprint",
	"labels",
	"cpuPlatfrom",
	"creationTimestamp",
	"deletionProtection",
	"description",
	"name",
	"metadata",
	"selfLink",
	"status",
	"tags",
	"zone",
	"machineType",
	"canIdForward",
    ]

    return slice_arr(instances, instance_keys)

if __name__ == "__main__":
    ni = Interface()
    instances = list_instances()
    print('Adding {0} instance(s) to the output `instances`'.format(len(instances)))
    ni.ouputs.set("instances", instances)

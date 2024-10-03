import os
import json
import yaml
import sys
from cloudflare import Cloudflare


def get_env(key):
    value = os.environ.get(key)
    if value is None:
        print(f"{key} can't be empty")
        exit(1)
    return value

def load_env():
    return {
            "ZONE_ID": get_env("ZONE_ID"),
            "CLOUDFLARE_EMAIL": get_env("CLOUDFLARE_EMAIL"),
            "CLOUDFLARE_API_KEY": get_env("CLOUDFLARE_API_KEY"),
            "DOMAIN": get_env("DOMAIN"),
    }
    
config = load_env()

cf = Cloudflare(
        api_email=config.get("CLOUDFLARE_EMAIL"),
        api_key=config.get("CLOUDFLARE_API_KEY"),
)

def print_help():
    print("Usage: terraform show --json | python3 main.py")

def parse_input():
    if not sys.stdin.isatty():
        input_data = sys.stdin.read().strip()
        return json.loads(input_data)
    else:
        print_help()
        sys.exit(1)

def create_inventory(terraform_data):
    inventory = {
            'all': {
                'hosts': {}
                }
            }

    for resource in terraform_data['values']['root_module']['resources']:
        if resource['type'] == 'openstack_compute_instance_v2':
            ip = resource['values']['access_ip_v4']
            inventory['all']['hosts'][ip] = {
                    'ansible_user': 'root',
                    'ansible_port': 22
                    }
    return inventory

def write_inventory_to_file(inventory):
    with open('inventory.yml', 'w') as file:
        yaml.dump(inventory, file, indent=2)

def get_dns_records_list():
    return cf.dns.records.list(zone_id=config["ZONE_ID"]).model_dump()

def get_dns_record_dict(records):
    return {record["name"]: record for record in records["result"]}

def get_dns_record(name, record_dict):
    return record_dict.get(name)

def create_dns_record(type, name, content, proxied):
    return cf.dns.records.create(zone_id=config["ZONE_ID"], type=type, name=name, content=content, proxied=proxied)

def delete_dns_record(dns_record_id):
    return cf.dns.records.delete(dns_record_id=dns_record_id, zone_id=config["ZONE_ID"])

def main():
    terraform_data = parse_input()
    inventory = create_inventory(terraform_data)
    write_inventory_to_file(inventory)

    ip_address = list(inventory["all"]["hosts"].keys())[0]

    records = get_dns_records_list()
    records_dict = get_dns_record_dict(records)

    record = records_dict.get(f"nova.{config['DOMAIN']}")

    if record:
        deleted = delete_dns_record(record["id"])
        if deleted:
            created = create_dns_record("A", f"nova.{config['DOMAIN']}", ip_address, True)
            if created:
                print("DNS record updated")
    else:
        created = create_dns_record("A", f"nova.{config['DOMAIN']}", ip_address, True)
        if created:
            print("New DNS record created")

if __name__ == "__main__":
    main()


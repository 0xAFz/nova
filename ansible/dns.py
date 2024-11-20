import os
import sys
import yaml
import json
from datetime import datetime
from cloudflare import Cloudflare

def get_env(key):
    value = os.environ.get(key)
    if value is None or value.strip() == "":
        print(f"{key} can't be empty")
        sys.exit(1)
    return value

def load_env():
    return {
            "DOMAIN": get_env("DOMAIN"),
            "SUBDOMAIN": get_env("SUBDOMAIN"),
            "CLOUDFLARE_EMAIL": get_env("CLOUDFLARE_EMAIL"),
            "CLOUDFLARE_API_KEY": get_env("CLOUDFLARE_API_KEY"),
            "ZONE_ID": get_env("ZONE_ID"),
            }

def load_inventory():
    if not os.path.exists("ansible/hosts.yml"):
        print("ansible/hosts.yml does not exist.")
        sys.exit(1)

    with open("ansible/hosts.yml", "r") as file:
        inventory = yaml.safe_load(file)

    return inventory


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
    inventory = load_inventory()
    ip_address = list(inventory["all"]["hosts"].keys())[0]

    records = get_dns_records_list()
    records_dict = get_dns_record_dict(records)

    record = records_dict.get(f"{config['SUBDOMAIN']}.{config['DOMAIN']}")

    if record:
        deleted = delete_dns_record(record["id"])
        if deleted:
            created = create_dns_record("A", f"{config['SUBDOMAIN']}.{config['DOMAIN']}", ip_address, True)
            if created:
                print("DNS record updated")
    else:
        created = create_dns_record("A", f"{config['SUBDOMAIN']}.{config['DOMAIN']}", ip_address, True)
        if created:
            print("New DNS record created")

if __name__ == "__main__":
    config = load_env()

    cf = Cloudflare(
            api_email=config.get("CLOUDFLARE_EMAIL"),
            api_key=config.get("CLOUDFLARE_API_KEY"),
    )

    main()

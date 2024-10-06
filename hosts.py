import json
import yaml
import sys


def print_help():
    print("Usage: terraform output -json | python3 hosts.py")


def parse_input():
    if not sys.stdin.isatty():
        input_data = sys.stdin.read().strip()
        return json.loads(input_data)
    else:
        print_help()
        sys.exit(1)


def create_inventory(terraform_data):
    inventory = {"all": {"hosts": {}}}

    ip = terraform_data["instance_public_ip"]["value"]

    inventory["all"]["hosts"][ip] = {
        "ansible_user": "root",
        "ansible_port": 22,
    }

    return inventory


def write_inventory_to_file(inventory):
    with open("inventory.yml", "w") as file:
        yaml.dump(inventory, file, indent=2)


def main():
    terraform_data = parse_input()
    inventory = create_inventory(terraform_data)
    write_inventory_to_file(inventory)


if __name__ == "__main__":
    main()

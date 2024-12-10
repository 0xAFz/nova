#!/bin/sh

set -euo pipefail

cd $(dirname "$0") || exit 1

set -o allexport
source .env
set +o allexport

activate_venv() {
    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
        source .venv/bin/activate
        pip install -r requirements.txt
    else
        source .venv/bin/activate
    fi
}

check_ping() {
    ansible all -i ansible/inventory/hosts.yml -m ping --timeout 1
}

up() {
    terraform -chdir=terraform init && \
    terraform -chdir=terraform apply -auto-approve && \
    terraform -chdir=terraform output -json | python3 ansible/inventory/dynamic.py

    if [ "$?" -ne 0 ]; then
        echo "dynamic.py failed to generate hosts.yml file. Exiting..."
        exit 1
    fi

    if [ -n "$DOMAIN" ]; then
        python3 dns.py

        if [ "$?" -ne 0 ]; then
            echo "dns.py failed to create dns record. Exiting..."
            exit 1
        fi
    else
        echo "DOMAIN is not set. Skipping DNS setup."
    fi

    until check_ping; do
        echo "Waiting for VM to become reachable..."
        sleep 1
    done

    ansible-playbook -i ansible/inventory/hosts.yml ansible/vpn.yml
}

down() {
    terraform -chdir=terraform destroy -auto-approve
}

case "$1" in
    up)
        activate_venv
        up
        ;;
    down)
        down
        ;;
    *)
        echo "Action not found. Use 'up' or 'down'."
        exit 1
        ;;
esac

#!/bin/sh

. ./.env

activate_venv() {
    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
        . .venv/bin/activate
        pip install -r ansible/requirements.txt
    else
        . .venv/bin/activate
    fi
}

check_ping() {
    ansible all -i ansible/hosts.yml -m ping --timeout 1
}

run_up() {
    terraform -chdir=terraform init && \
    terraform -chdir=terraform plan && \
    terraform -chdir=terraform apply -auto-approve && \
    terraform -chdir=terraform output -json | python3 ansible/dynamic.py || \
    exit 1

    if [ "$?" -ne 0 ]; then
        echo "hosts.py failed to generate inventory.yml file. Exiting..."
        exit 1
    fi

    if [ -n "$DOMAIN" ]; then
        python3 ansible/dns.py

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

    ansible-playbook -i ansible/hosts.yml ansible/xui.yml
}

run_down() {
    terraform -chdir=terraform destroy -auto-approve
}

case "$1" in
    up)
        activate_venv
        run_up
        ;;
    down)
        run_down
        ;;
    *)
        echo "Action not found. Use 'up' or 'down'."
        exit 1
        ;;
esac

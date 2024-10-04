#!/bin/sh

. ./.env

if [ ! -d ".venv" ]; then
	python3 -m venv .venv
	. .venv/bin/activate
	pip install -r requirements.txt
else
	. .venv/bin/activate
fi

check_ping() {
	ansible all -i inventory.yml -m ping --timeout 1
}

terraform init && \
	terraform plan && \
	terraform apply -auto-approve && \
	terraform show -json | python3 main.py

if [ "$?" -eq 0 ]; then
    until check_ping; do
        echo "Waiting for VM to become reachable..."
        sleep 1
    done

    ansible-playbook -i inventory.yml xui.yml
fi


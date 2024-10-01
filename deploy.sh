#!/bin/bash

source .venv/bin/activate

export XUI_USERNAME=admin
export XUI_PASSWORD=admin
export XUI_PORT=2053

export TF_VAR_OS_USERNAME=openstack_username
export TF_VAR_OS_TENANT_NAME=openstack_username
export TF_VAR_OS_PASSWORD=openstack_password
export TF_VAR_OS_AUTH_URL=openstack_auth_url
export TF_VAR_OS_REGION_NAME=openstack_region

check_ping() {
	ansible all -i inventory.yml -m ping --timeout 1
}

terraform init && \
	terraform plan && \
	terraform apply -auto-approve && \
	terraform show -json | python3 main.py


until check_ping; do
	echo "Waiting for VM to become reachable..."
	sleep 1
done

ansible-playbook -i inventory.yml xui.yml


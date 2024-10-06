#!/bin/sh

. ./.env

activate_venv() {
	if [ ! -d ".venv" ]; then
		python3 -m venv .venv
		. .venv/bin/activate
		pip install -r requirements.txt
	else
		. .venv/bin/activate
	fi
}

check_ping() {
	ansible all -i inventory.yml -m ping --timeout 1
}

run_up() {
	terraform init && \
	terraform plan && \
	terraform apply -auto-approve && \
	terraform output -json | python3 hosts.py

	if [ "$?" -ne 0 ]; then
		echo "hosts.py failed to generate inventory.yml file. Exiting..."
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

	ansible-playbook -i inventory.yml xui.yml
}

run_down() {
	terraform destroy -auto-approve
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

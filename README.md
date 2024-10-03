# Nova

This project provides an end-to-end automation solution for setting up a VPN using Terraform, Ansible, Bash, and Python3. It's designed to simplify the process of deploying a VPN server on OpenStack and managing DNS with Cloudflare.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

1. [terraform](https://terraform.io)
2. [ansible](https://docs.ansible.com)
3. [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
4. [python3](https://python.org)

You'll also need to have accounts and credentials for:

- OpenStack
- Cloudflare

## Setup Instructions

1. Clone this repository to your local machine.

2. Edit the following files to customize the setup for your environment:

   a. In `main.tf`:
      - Change the `flavor_name` in the `openstack_compute_instance_v2` resource to match your desired OpenStack instance type.

   b. In `deploy.sh`:
      - Set the following environment variables:
        - `XUI_USERNAME`: Desired username for X-UI panel
        - `XUI_PASSWORD`: Desired password for X-UI panel
        - `XUI_PORT`: Desired port for X-UI panel
        - `DOMAIN`: Your domain name
        - `CLOUDFLARE_EMAIL`: Your Cloudflare account email
        - `CLOUDFLARE_API_KEY`: Your Cloudflare API key
        - `ZONE_ID`: Your Cloudflare zone ID
        - `TF_VAR_OS_USERNAME`: Your OpenStack username
        - `TF_VAR_OS_TENANT_NAME`: Your OpenStack tenant name
        - `TF_VAR_OS_PASSWORD`: Your OpenStack password
        - `TF_VAR_OS_AUTH_URL`: Your OpenStack authentication URL
        - `TF_VAR_OS_REGION_NAME`: Your OpenStack region

3. Ensure your SSH public key is located at `~/.ssh/id_rsa.pub`. This will be used to access the created VM.

## Usage

Once you've completed the setup, follow these steps to deploy your VPN:

1. Open a terminal and navigate to the project directory.

2. Make the `deploy.sh` script executable:
   ```
   chmod +x deploy.sh
   ```

3. Run the deployment script:
   ```
   ./deploy.sh
   ```

4. The script will perform the following actions:
   - Create a Python virtual environment and install required packages
   - Set up environment variables
   - Initialize Terraform and create the infrastructure
   - Use Python to process Terraform output
   - Wait for the VM to become reachable
   - Run the Ansible playbook to configure the X-UI panel

5. Once the script completes, your VPN server should be set up and ready to use.

## What's Happening Behind the Scenes

1. Terraform creates a VM on OpenStack with the specified configuration.
2. A Python script processes the Terraform output to create an Ansible inventory.
3. Ansible connects to the VM and installs/configures the X-UI panel.
4. Cloudflare DNS is updated to point your domain to the new VM's IP address.

## Troubleshooting

- If the script fails, check the error messages for clues about what went wrong.
- Ensure all credentials and environment variables are correctly set.
- Verify that your OpenStack and Cloudflare accounts have the necessary permissions.

## Security Note

This script contains sensitive information (passwords, API keys). Ensure you keep the `deploy.sh` file secure and do not share it publicly.

## Customization

You can modify the `main.tf` file to change the VM specifications or the `xui.yml` Ansible playbook to adjust the VPN configuration.

## Support

If you encounter any issues or have questions, please open an issue in the project's repository.

Remember to replace any placeholder values with your actual information before using this setup.

# Nova

Nova automates the setup of a VPN server using Terraform, Ansible, Bash, and Python3 on OpenStack, with optional DNS management via Cloudflare. The project simplifies VPN deployment and configuration through a unified automation script, handling everything from infrastructure provisioning to domain setup.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setup Instructions](#setup-instructions)
3. [Usage](#usage)
4. [Environment Configuration](#environment-configuration)
   - [Populating the `.env` File](#populating-the-env-file)
5. [Detailed Configuration Steps](#detailed-configuration-steps)
   - [Cloudflare Credentials](#cloudflare-credentials)
   - [OpenStack Credentials](#openstack-credentials)
   - [SSH Key Pair Generation](#ssh-key-pair-generation)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure the following software is installed on your system:

1. **[Terraform](https://terraform.io)**
2. **[Ansible](https://docs.ansible.com)**
3. **[Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))**
4. **[Python3](https://python.org)**

You will also need accounts for:
- **OpenStack** (for infrastructure)
- **Cloudflare** (if using domain-based setup)

## Setup Instructions

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/0xAFz/nova.git
   cd nova/
   ```

2. Copy the `.env.example` file to `.env`:

   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file and replace the placeholders with actual values (refer to the [Environment Configuration](#environment-configuration) section).

4. Make the `nova.sh` script executable:

   ```bash
   chmod +x nova.sh
   ```

5. You are now ready to run the script and deploy the VPN server!

## Usage

Nova supports two main operations: `up` and `down`.

- To start and deploy the VPN server, run:

   ```bash
   ./nova.sh up
   ```

   This will:
   - Initialize Terraform and create the infrastructure.
   - Set up the server with VPN capabilities.
   - Optionally configure DNS records through Cloudflare (if a domain is provided).

- To destroy the VPN server and associated resources, run:

   ```bash
   ./nova.sh down
   ```

## Environment Configuration

### Populating the `.env` File

The `.env` file contains crucial environment variables needed for the project. You must update the placeholder values with your actual credentials and information.

The variables in `.env` are used across the Terraform, Ansible, and Python scripts to automate the setup. Ensure that all values are accurate before running the automation.

### Steps to Replace `.env` Values

1. **XUI Panel Credentials**:
   - Set the username and password you want for the XUI panel.
   - Specify the port for the XUI panel (e.g., `2053`).

2. **Domain and Cloudflare Setup** (Optional):
   - If you are using a domain with Cloudflare, fill in your Cloudflare email, API key, and Zone ID. Leave `DOMAIN` empty if you’re not using DNS.

3. **OpenStack Configuration**:
   - Replace the placeholders with your OpenStack credentials, which can be obtained from the OpenStack dashboard or the OpenRC file.

4. **SSH and VM Configuration**:
   - Ensure the path to your SSH public key is correct (usually `~/.ssh/id_rsa.pub`).
   - Specify the name, image, flavor, and network for the VM that will be created.

## Detailed Configuration Steps

### Cloudflare Credentials

To use DNS management via Cloudflare:

1. Log into your Cloudflare account.
2. Go to **My Profile** > **API Tokens**.
3. Create a new API token with DNS edit permissions.
4. Copy the API key, email, and Zone ID into the `.env` file.

Reference: [Cloudflare API Documentation](https://developers.cloudflare.com/api/)

### OpenStack Credentials

To obtain OpenStack credentials:

1. Log into the OpenStack dashboard.
2. Go to **Access & Security** > **API Access** and download the OpenRC file.
3. Source the OpenRC file and copy the values into your `.env` file.

Alternatively, use the OpenStack CLI:

```bash
openstack credentials show
```

Reference: [OpenStack CLI Documentation](https://docs.openstack.org/python-openstackclient/latest/)

### SSH Key Pair Generation

If you don’t already have an SSH key pair:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This will generate `id_rsa` (private key) and `id_rsa.pub` (public key) in your `~/.ssh/` directory.

## Troubleshooting

- **General Failures**: Check the error messages and logs to understand the cause of the failure.
- **Environment Variables**: Ensure all values in the `.env` file are correct.
- **SSH Issues**: Verify that your SSH key pair is generated correctly and located in the right directory (`~/.ssh/id_rsa.pub`).
- **Cloudflare DNS**: If using a domain, confirm that your DNS records are correctly set up in Cloudflare.
- **Permissions**: Ensure that your OpenStack and Cloudflare accounts have the necessary permissions.

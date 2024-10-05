# Nova

This project provides an end-to-end automation solution for setting up a VPN using Terraform, Ansible, Bash, and Python3. It's designed to simplify the process of deploying a VPN server on OpenStack, with optional DNS management through Cloudflare.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Setup Instructions](#setup-instructions)
3. [Usage](#usage)
4. [Detailed Configuration Steps](#detailed-configuration-steps)
   - [Cloudflare Credentials](#cloudflare-credentials)
   - [OpenStack Credentials](#openstack-credentials)
   - [SSH Key Pair Generation](#ssh-key-pair-generation)
   - [Domain Certificates](#domain-certificates)
   - [Terraform Configuration](#terraform-configuration)
5. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following installed on your system:

1. [terraform](https://terraform.io)
2. [ansible](https://docs.ansible.com)
3. [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
4. [python3](https://python.org)

You'll also need accounts for:
- OpenStack
- Cloudflare (if using the domain-based setup)

## Setup Instructions

1. Clone this repository to your local machine.
   ```bash
   git clone https://github.com/0xAFz/nova.git

   cd nova/
   ```

2. Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file and fill in your specific details. See the [Detailed Configuration Steps](#detailed-configuration-steps) section for guidance on obtaining these credentials.

4. If you're using a domain, ensure the `DOMAIN` variable in `.env` is set. If not using a domain, either comment out this line or set it to an empty value:
   ```
   DOMAIN=
   ```

5. Make the `nova.sh` script executable:
   ```
   chmod +x nova.sh
   ```

6. Review and update the `main.tf` file with your specific OpenStack details (see [Terraform Configuration](#terraform-configuration)).

7. If using a domain, generate SSL certificates (see [Domain Certificates](#domain-certificates)).

## Usage

The project now supports two main operations: `up` and `down`.

To start the VPN server:
```bash
./nova.sh up
```

To destroy the VPN server and associated resources:
```bash
./nova.sh down
```

## Detailed Configuration Steps

### Cloudflare Credentials

If you're using a domain with Cloudflare:

1. Log in to your Cloudflare account.
2. Navigate to "My Profile" > "API Tokens".
3. Create a new API token with permissions for DNS editing.
4. Copy the API key, email, and Zone ID into your `.env` file.

Reference: [Cloudflare API Documentation](https://developers.cloudflare.com/api/)

### OpenStack Credentials

To obtain OpenStack credentials:

1. Log in to your OpenStack dashboard.
2. Navigate to "Access & Security" > "API Access".
3. Download the OpenRC file.
4. Source the OpenRC file and copy the values into your `.env` file.

Alternatively, use the OpenStack CLI:
```bash
openstack credentials show
```

Reference: [OpenStack CLI Documentation](https://docs.openstack.org/python-openstackclient/latest/)

### SSH Key Pair Generation

Generate an SSH key pair if you don't already have one:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This will create `id_rsa` (private key) and `id_rsa.pub` (public key) in your `~/.ssh/` directory.

### Domain Certificates

If using a domain, generate SSL certificates using acme.sh:

1. Install acme.sh:
   ```bash
   curl https://get.acme.sh | sh
   ```

2. Generate certificates in standalone mode:
   ```bash
   acme.sh --issue -d your_domain.tld --standalone
   ```

3. Copy the generated certificates:
   ```bash
   cp ~/.acme.sh/your_domain.tld/fullchain.cer       roles/xui/files/certs/pubkey.pem
   cp ~/.acme.sh/your_domain.tld/your_domain.tld.key roles/xui/files/certs/private.key
   ```

Reference: [acme.sh Documentation](https://github.com/acmesh-official/acme.sh)

### Terraform Configuration

Update `main.tf` with your specific OpenStack details:

1. Set the correct `image_name` for your desired OS.
2. Update `flavor_name` to match your preferred instance type.
3. Adjust the `network` name if different in your OpenStack setup.

Example:
```hcl
resource "openstack_compute_instance_v2" "nova" {
  name            = "nova"
  image_name      = "Ubuntu-24.04-amd64"
  flavor_name     = "m1.small"
  key_pair        = openstack_compute_keypair_v2.nova_pk.name
  security_groups = ["allow_all"]
  network {
    name = "your_network_name"
  }
  # ... rest of the configuration
}
```

## Troubleshooting

- If the script fails, check the error messages for clues about what went wrong.
- Ensure all credentials in the `.env` file are correct.
- Verify that your OpenStack and Cloudflare (if used) accounts have the necessary permissions.
- If using a domain, make sure the DNS records are properly set up in Cloudflare.
- Check that the SSH key pair is correctly generated and placed in the default location (`~/.ssh/id_rsa.pub`).

For any persistent issues, please open an issue in the project's repository.

Remember to keep your `.env` file and SSH keys secure and never share them publicly.

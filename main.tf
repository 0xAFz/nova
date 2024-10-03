terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  user_name   = var.OS_USERNAME
  tenant_name = var.OS_TENANT_NAME
  password    = var.OS_PASSWORD
  auth_url    = var.OS_AUTH_URL
  region      = var.OS_REGION_NAME
}

variable "OS_USERNAME" {
  type        = string
}

variable "OS_TENANT_NAME" {
  type        = string
}

variable "OS_PASSWORD" {
  type        = string
}

variable "OS_AUTH_URL" {
  type        = string
}

variable "OS_REGION_NAME" {
  type        = string
}

resource "openstack_compute_keypair_v2" "nova_pk" {
  name       = "nova_pk"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "openstack_compute_instance_v2" "nova" {
  name            = "nova"
  image_name      = "Ubuntu-24.04-amd64"
  flavor_name     = "flavor_name"
  key_pair        = openstack_compute_keypair_v2.nova_pk.name

  security_groups = ["allow_all"]

  network {
    name = "Internet-18"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
              echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
              sysctl -p
              EOF

}


resource "openstack_compute_keypair_v2" "nova_pk" {
  name       = "nova_pk"
  public_key = file(var.public_key_path)
}

resource "openstack_compute_instance_v2" "nova" {
  name        = var.machine_name
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.nova_pk.name

  security_groups = var.security_groups

  network {
    name = var.network_name
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
              echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
              sysctl -p
              EOF

}


output "instance_public_ip" {
  value       = openstack_compute_instance_v2.nova.access_ip_v4
  description = "The public IP of instance"
}


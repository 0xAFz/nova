variable "os_username" {
  description = "OpenStack username"
  type        = string
}

variable "os_tenant_name" {
  description = "OpenStack tenant name"
  type        = string
}

variable "os_password" {
  description = "OpenStack password"
  type        = string
  sensitive   = true
}

variable "os_auth_url" {
  description = "OpenStack authentication URL"
  type        = string
}

variable "os_region_name" {
  description = "OpenStack region name"
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "machine_name" {
  description = "Hostname of VM"
  type        = string
  default     = "nova"
}

variable "image_name" {
  description = "OpenStack operation system image"
  type        = string
}

variable "flavor_name" {
  description = "OpenStack flavor name"
  type        = string
}

variable "network_name" {
  description = "OpenStack network name"
  type        = string
}

variable "security_groups" {
  description = "OpenStack security groups list"
  type        = list(string)
  default     = ["allow_all"]
}


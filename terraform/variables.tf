variable project {
  description = "Project ID"
}

variable region {
  description = "Region, location of VM"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
}

variable "app_count" {
  description = "number off app instances"
  default     = "1"
}

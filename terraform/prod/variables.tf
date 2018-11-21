variable project {
  description = "Project ID"
}

variable disk_image {
  description = "Disk image"
}


variable "app_count" {
  description = "number off app instances"
  default     = "1"
}

variable region {
  description = "Region, location of VM"
  default     = "europe-west1"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "app-reddit-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "mongo-base"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
  default = "~/.ssh/appuser.pub"
}

variable zone {
  description = "zone of app vm"
  default     = "europe-west1-b"
}

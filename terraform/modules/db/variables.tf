variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "mongo-base"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "zone of db vm"
  default     = "europe-west1-b"
}

variable "db_port" {
  description = "allow db port"
  default     = ["27017"]
}

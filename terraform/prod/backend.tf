terraform {
  backend "gcs" {
    bucket = "evgeny-infra-prod-bucket-2"
    prefix = "terraform"
  }
}

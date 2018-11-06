terraform {
  backend "gcs" {
    bucket = "evgeny-infra-stage-bucket-1"
    prefix = "terraform"
  }
}

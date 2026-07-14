terraform {
  backend "s3" {
    bucket       = "lesson-7-tf-state-simakhin"
    key          = "lesson-7/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }
}
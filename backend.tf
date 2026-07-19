# terraform {
#   backend "s3" {
#     bucket       = "lesson-8-9-tf-state-simakhin"
#     key          = "lesson-8-9/terraform.tfstate"
#     region       = "us-west-2"
#     use_lockfile = true
#     encrypt      = true
#   }
# }
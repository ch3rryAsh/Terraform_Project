
data "terraform_remote_state" "remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-ash-t3"
    key     = "stage/tfstate.tf"
    region  = "ap-northeast-2"
    profile = "terraform_user"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform_user"
}

/* ================ */

# AWS S3 Bucket 생성
resource "aws_s3_bucket" "terraform_state" {
  bucket = "myterraform-bucket-state-ash-t3"
  tags = {
    Name = "terraform_state"
  }

  force_destroy = true

}

# S3 bucket에서 사용 할 KMS 리소스 정의
resource "aws_kms_key" "terraform_state_kms" {
  description             = "terraform_state_kms"
  deletion_window_in_days = 7
}

# S3 bucket 암호화 (KMS 방식 사용)
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_sec" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "terraform_state_ver" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 다이나모 DB : AWS의 분산형 KEY-Value 저장소
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "myTerraform-bucket-lock-ash-t3"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
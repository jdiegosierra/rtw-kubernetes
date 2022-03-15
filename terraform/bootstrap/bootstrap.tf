resource "aws_dynamodb_table" "clusters_dynamodb_tf_state_lock" {
  name           = "${var.clusters_name_prefix}-terraform-state-lock-dynamodb"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "clusters_vpc_dynamodb_tf_state_lock" {
  name           = "${var.clusters_name_prefix}-vpc-terraform-state-lock-dynamodb"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "clusters_tf_state_s3_bucket" {
  bucket = "${var.clusters_name_prefix}-terraform-state"
  acl    = "private"
  versioning {
    enabled = false
  }
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name      = "${var.clusters_name_prefix} S3 Remote Terraform State Store"
    ManagedBy = "terraform"
  }
}

resource "aws_s3_bucket" "clusters_vpc_tf_state_s3_bucket" {
  bucket = "${var.clusters_name_prefix}-vpc-terraform-state"
  acl    = "private"
  versioning {
    enabled = false
  }
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name      = "${var.clusters_name_prefix} VPC S3 Remote Terraform State Store"
    ManagedBy = "terraform"
  }
}
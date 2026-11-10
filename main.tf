
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# EC2 Security Group
resource "aws_security_group" "demo_sg" {
  name        = "terraform-scan-demo"
  description = "Demo security group"

  # INTENTIONALLY INSECURE: SSH open to the internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # INTENTIONALLY INSECURE: All traffic allowed
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Scanning-Demo"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "nextgenit-terraform-scan-demo-2026-unique"

  tags = {
    Name = "Terraform-Scan-Demo"
  }
}

# INTENTIONALLY INSECURE: Public access is not blocked
resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

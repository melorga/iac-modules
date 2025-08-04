terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "static_site" {
  source = "../../modules/s3-static-site"

  bucket_name        = "example-static-site-${random_id.bucket_suffix.hex}"
  force_destroy      = true
  versioning_enabled = true

  tags = {
    Environment = "example"
    Project     = "static-site-demo"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Upload sample files
resource "aws_s3_object" "index" {
  bucket       = module.static_site.bucket_name
  key          = "index.html"
  content      = templatefile("${path.module}/files/index.html", {
    site_name = "Example Static Site"
    timestamp = timestamp()
  })
  content_type = "text/html"
  etag         = md5(templatefile("${path.module}/files/index.html", {
    site_name = "Example Static Site"
    timestamp = timestamp()
  }))
}

resource "aws_s3_object" "error" {
  bucket       = module.static_site.bucket_name
  key          = "error.html"
  content      = file("${path.module}/files/error.html")
  content_type = "text/html"
  etag         = filemd5("${path.module}/files/error.html")
}

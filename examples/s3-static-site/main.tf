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

# Upload sample files. Etag is derived from file content (filemd5) so plans
# only show drift when the file actually changes.
resource "aws_s3_object" "index" {
  bucket       = module.static_site.bucket_name
  key          = "index.html"
  source       = "${path.module}/files/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/files/index.html")
}

resource "aws_s3_object" "error" {
  bucket       = module.static_site.bucket_name
  key          = "error.html"
  source       = "${path.module}/files/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/files/error.html")
}

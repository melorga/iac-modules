output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket_domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "website_url" {
  description = "URL of the website"
  value = var.domain_name != null ? (
    var.subdomain != null ? 
    "https://${var.subdomain}.${var.domain_name}" : 
    "https://${var.domain_name}"
  ) : "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "route53_record_fqdn" {
  description = "FQDN of the Route 53 record"
  value = var.domain_name != null ? (
    var.subdomain != null ? 
    "${var.subdomain}.${var.domain_name}" : 
    var.domain_name
  ) : null
}

variable "bucket_name" {
  description = "Name of the S3 bucket for static website hosting"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be a valid S3 bucket name."
  }
}

variable "domain_name" {
  description = "Domain name for the website (optional)"
  type        = string
  default     = null
}

variable "subdomain" {
  description = "Subdomain for the website (optional)"
  type        = string
  default     = null
}

variable "domain_aliases" {
  description = "List of domain aliases for CloudFront"
  type        = list(string)
  default     = []
}

variable "ssl_certificate_arn" {
  description = "ARN of SSL certificate in ACM (us-east-1)"
  type        = string
  default     = null
}

variable "index_document" {
  description = "Name of the index document"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Name of the error document"
  type        = string
  default     = "error.html"
}

variable "versioning_enabled" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
  validation {
    condition = contains([
      "PriceClass_All",
      "PriceClass_200",
      "PriceClass_100"
    ], var.cloudfront_price_class)
    error_message = "Price class must be one of: PriceClass_All, PriceClass_200, PriceClass_100."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

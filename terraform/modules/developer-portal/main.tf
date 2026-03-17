# Creates:

# • S3 hosting
# • CloudFront distribution

#create s3 bucket to host the portal. This is a simple static website that can be accessed globally with low latency via CloudFront.

resource "aws_s3_bucket" "portal_bucket" {

  bucket = "platform-developer-portal"

}

resource "aws_s3_bucket_public_access_block" "portal" {

  bucket = aws_s3_bucket.portal_bucket.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "portal_policy" {

  bucket = aws_s3_bucket.portal_bucket.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = "*"

        Action = "s3:GetObject"

        Resource = "${aws_s3_bucket.portal_bucket.arn}/*"
      }
    ]
  })
}

# cloudrfont distribution to serve the portal globally with low latency. This also allows us to put the portal behind HTTPS with a custom domain if desired.
resource "aws_cloudfront_distribution" "portal" {

  enabled = true

  origin {

    domain_name = aws_s3_bucket.portal_bucket.bucket_regional_domain_name
    origin_id   = "portalS3"

  }

  default_cache_behavior {

    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    target_origin_id = "portalS3"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {

      query_string = false

      cookies {
        forward = "none"
      }

    }

  }


  resource "aws_s3_object" "portal_files" {

    for_each = fileset("${path.module}/../../developer-portal", "*")

    bucket = aws_s3_bucket.portal_bucket.id

    key = each.value

    source = "${path.module}/../../developer-portal/${each.value}"

    etag = filemd5("${path.module}/../../developer-portal/${each.value}")

}

#fileset()
# fileset("${path.module}/../../developer-portal", "*")

# This tells Terraform:

# "Look inside the developer-portal folder and return all files."

  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

# If you change the portal code later:

# app.js updated
# Terraform detects the change and re-uploads the file automatically.

# Without this, Terraform may not detect file changes.

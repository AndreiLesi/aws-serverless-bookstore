resource "random_uuid" "bucket_id" {}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "serverless-bookstore-${random_uuid.bucket_id.result}"  # Change to a unique bucket name
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.website_bucket.bucket}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "prod" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_ownership_controls.prod, aws_s3_bucket_public_access_block.prod ]

}

resource "aws_s3_bucket_ownership_controls" "prod" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "prod" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
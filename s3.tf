resource "aws_s3_bucket" "elblogs-store" {
  bucket = "elblogs-store-${random_string.random.result}"
  acl    = "public"
  versioning {
    enabled = true
    }
  tags = {
    Name = "elblogs store"
  }
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}


resource "aws_s3_bucket" "heartbeat_bucket" {
  bucket = "${var.collection_name}-bucket"
  acl    = "public-read-write"

}
output "s3_buckup_name" {
 value = "${aws_s3_bucket.s3_bucket.bucket}"
 description = "The bucket name for the bootcamp"
}

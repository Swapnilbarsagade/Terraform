resource "aws_iam_group" "readonly_group" {
  name = var.group_name
}

# Attach the S3 read-only policy to the group
resource "aws_iam_group_policy_attachment" "s3_readonly_attachment" {
  group      = aws_iam_group.readonly_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
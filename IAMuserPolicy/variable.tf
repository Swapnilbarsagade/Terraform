variable "iam_user_name" {
  description = "Name of the IAM user to create."
  type        = string
  default     = "this_is_user"
}

variable "policy_arn" {
  description = "The ARN of the IAM policy to attach to the user."
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"  # Amazon S3 read-only policy as an example
}

resource "aws_iam_user" "this_is_user" {
  name = var.iam_user_name
  force_destroy = true  # Set to true to delete all associated resources (e.g., access keys) with the user
}

resource "aws_iam_user_policy_attachment" "example_user_policy" {
  user       = aws_iam_user.this_is_user.name
  policy_arn = var.policy_arn  # Attach the specified policy to the user
}

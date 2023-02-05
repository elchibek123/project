resource "aws_iam_role" "app_role" {
  name               = "app_role-dev-ue1-rl-001"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      }
    }
  ]
}
POLICY

  tags = merge(
    local.common_tags,
    {
      "Name" = "app_role-dev-ue1-rl-001"
    }
  )
}

resource "aws_iam_role_policy_attachment" "app_role_attach" {
  policy_arn = data.aws_iam_policy.app_policy.arn
  role       = aws_iam_role.app_role.name
}
locals {
  policy = jsondecode(file("policy.json"))
}

resource "aws_iam_policy" "eks_attach_policy" {
  for_each = local.policy

  name = "eks-${each.key}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = each.value.policy
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_attach_policy_attachment" {
  for_each = aws_iam_policy.eks_attach_policy

  role       = var.nodegroup_iam_role_name
  policy_arn = each.value.arn
}

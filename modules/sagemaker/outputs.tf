output "sagemaker_notebook_instance_name" {
  value = aws_sagemaker_notebook_instance.example.name
}

output "sagemaker_execution_role_arn" {
  value = aws_iam_role.sagemaker_execution_role.arn
}
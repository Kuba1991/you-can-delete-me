# EKS Cluster Name
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.my_cluster.name
}

# EKS Cluster ARN
output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.my_cluster.arn
}

# EKS Cluster Endpoint
output "eks_cluster_endpoint" {
  description = "The endpoint URL of the EKS cluster"
  value       = aws_eks_cluster.my_cluster.endpoint
}

# EKS Cluster Certificate Authority Data
output "eks_cluster_ca_data" {
  description = "The certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.my_cluster.certificate_authority[0].data
}

# Worker Nodes Security Group ID
output "worker_sec_group_id" {
  description = "The security group ID for the worker nodes"
  value       = aws_security_group.eks_sec_group.id
}

# Worker Nodes Auto Scaling Group Name
output "worker_asg_name" {
  description = "The name of the worker node Auto Scaling Group"
  value       = aws_autoscaling_group.worker_asg.name
}

# Worker Node Instance Profile ARN
output "worker_instance_profile_arn" {
  description = "The instance profile ARN for the worker nodes"
  value       = aws_iam_role.eks_worker_role.arn
}



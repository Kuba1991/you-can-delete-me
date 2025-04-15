provider "aws" {
  region = "eu-west-1"
}

# VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# Subnet A Creation
resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

# Subnet B Creation
resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
  }
}

# Security Group for EKS
resource "aws_security_group" "eks_sec_group" {
  name        = "eks-sec-group"
  description = "Security group for EKS"
  vpc_id      = aws_vpc.main.id
}

# EKS Cluster Creation
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy_attachment]
}

# IAM Role for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Policy to EKS Role
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Fetch the latest EKS AMI
data "aws_ami" "eks" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-*-v*.*.*"]
  }
}

# Launch Configuration for Worker Nodes
resource "aws_launch_configuration" "worker_launch_config" {
  name                        = "worker-launch-config"
  image_id                    = data.aws_ami.eks.id
  instance_type               = "t3.medium"
  security_groups             = [aws_security_group.eks_sec_group.id]
  associate_public_ip_address = true
}

# Auto Scaling Group for Worker Nodes
resource "aws_autoscaling_group" "worker_asg" {
  desired_capacity     = 3
  max_size             = 3
  min_size             = 3
  vpc_zone_identifier  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  launch_configuration = aws_launch_configuration.worker_launch_config.id
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "eks_worker_role" {
  name = "eks-worker-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Policy to Worker Role
resource "aws_iam_role_policy_attachment" "eks_worker_policy_attachment" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# EKS Node Group
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  instance_types  = ["t3.medium"]
  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  depends_on = [aws_eks_cluster.my_cluster]
}

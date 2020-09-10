#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

#IAM Role
resource "aws_iam_role" "cluster-role" {
  provider = aws.staging
  name = "cluster-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  provider = aws.staging
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  provider = aws.staging
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster-role.name
}

#Security Group
resource "aws_security_group" "cluster-sg" {
  provider = aws.staging
  name        = "clusterSG"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cluster"
  }
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  provider = aws.staging
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster-sg.id
  source_security_group_id = aws_security_group.worker-node-sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  provider = aws.staging
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster-sg.id
  to_port           = 443
  type              = "ingress"
}

#EKS Service
resource "aws_eks_cluster" "eks-cluster" {
  provider = aws.staging
  name     = var.cluster-name
  role_arn = aws_iam_role.cluster-role.arn
  # endpoint_private_access = "true"

  vpc_config {
    security_group_ids = [aws_security_group.cluster-sg.id]
    subnet_ids         = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy,
  ]
}

#Node Group
resource "aws_eks_node_group" "nodegroup-private" {
  provider = aws.staging
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "exercise-staging-nodegroup-private"
  node_role_arn   = aws_iam_role.worker-node-role.arn
  subnet_ids      = [var.subnet_ids[0], var.subnet_ids[1], var.subnet_ids[2]]
  scaling_config {
    desired_size = 3
    max_size     = 12
    min_size     = 3
  }

  ami_type        = "AL2_x86_64"
  instance_types  = ["m5.large"]

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.eks-cluster.name}" = "shared"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.exeks-cluster-AmazonEKSServicePolicy,
  ]
}

# resource "aws_eks_node_group" "nodegroup-public" {
#   provider = aws.staging
#   cluster_name    = aws_eks_cluster.eks-cluster.name
#   node_group_name = "exercise-staging-nodegroup-public"
#   node_role_arn   = aws_iam_role.worker-node-role.arn
#   subnet_ids      = [var.subnet_ids[6], var.subnet_ids[7], var.subnet_ids[8]]
#   scaling_config {
#     desired_size = 6
#     max_size     = 12
#     min_size     = 3
#   }

#   ami_type        = "AL2_x86_64"
#   instance_types  = ["m5.large"]

#   tags = {
#     "kubernetes.io/cluster/${aws_eks_cluster.eks-cluster.name}" = "shared"
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   # depends_on = [
#   #   aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
#   #   aws_iam_role_policy_attachment.exeks-cluster-AmazonEKSServicePolicy,
#   # ]
# }
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks_node_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = var.private_subnets
    public_access_cidrs = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  ami_type = "AL2_x86_64"

  labels = {
    role = "example"
  }

  tags = local.common_tags
}

resource "kubernetes_config_map" "aws_vpc_cni" {
  metadata {
    name      = "aws-vpc-cni"
    namespace = "kube-system"
  }

  data = {
    "enable-ipv4"             = "true"
    "ipam"                    = "eni"
    "eniConfigLabelDef"       = "k8s.amazonaws.com/eniConfig"
    "assign_ipv4_address"     = "true"
    "use_primary_ip"          = "true"
    "custom_network_cidr"     = var.secondary_cidr
  }
}

resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  values = [
    <<EOF
clusterName: ${aws_eks_cluster.example.name}
serviceAccount:
  create: false
  name: aws-load-balancer-controller
region: ${var.region}
vpcId: ${aws_eks_cluster.example.vpc_id}
EOF
  ]
}

resource "helm_release" "coredns" {
  name       = "coredns"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "coredns"
  namespace  = "kube-system"
}
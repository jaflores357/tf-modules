module "eks" {
    source            = "terraform-aws-modules/eks/aws"
    cluster_name      = var.cluster_name
    subnets           = var.private_subnets
    enable_irsa       = true
    workers_role_name = local.workers_role_name
    vpc_id            = var.vpc_id
    worker_groups     = var.worker_groups
    tags              = merge(
        var.tags,
        local.module_tags
    )
}

module "alb_ingress_controller" {
    source           = "iplabs/alb-ingress-controller/kubernetes"
    version          = "3.1.0"
    k8s_cluster_type = "eks"
    k8s_namespace    = "kube-system"
    aws_region_name  = var.aws_region
    k8s_cluster_name = var.cluster_name
    providers        = { kubernetes = kubernetes }
    depends_on       = [ module.eks ]  
}

module "cluster_autoscaler_aws" {
    source                  = "cookielab/cluster-autoscaler-aws/kubernetes"
    version                 = "0.9.0"
    aws_iam_role_for_policy = local.workers_role_name
    depends_on              = [module.eks]  
    asg_tags                = [
        "k8s.io/cluster-autoscaler/enabled",
        "k8s.io/cluster-autoscaler/${var.cluster_name}",
    ]
}

module "external_dns_aws" {
    source                  = "cookielab/external-dns-aws/kubernetes"
    version                 = "0.9.0"
    domains                 = var.domains
    sources                 = ["ingress"]
    owner_id                = "kube-clb-main"
    aws_iam_role_for_policy = local.workers_role_name
    depends_on              = [module.eks]  
}

resource "aws_alb" "apps_ingress_nlb" {
  count = 0
  name = "apps-ingress-nlb"
  internal = true
  load_balancer_type = "network"
  subnets = [
    "${element(module.vpc.private_subnets, 0)}"
  ]
  ip_address_type = "ipv4"
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = false
  tags = {
    "service.k8s.aws/stack" = "kube-system/ingress-nginx-controller"
    "service.k8s.aws/resource" = "LoadBalancer"
    "elbv2.k8s.aws/cluster" = local.cluster_name
  }

  depends_on = [
    module.eks
  ]
}

resource "aws_lb_target_group" "nginx-tg" {

  count = 0
  name = "nginx-tg"
  port = 80
  protocol = "TCP"
  vpc_id = "vpc-05f6aca9527fc8e68"
  target_type = "instance"
  deregistration_delay = 5

  health_check {
    protocol = "TCP"
  }

  depends_on = [
    module.eks
  ]
}


resource "helm_release" "nginx-ingress-controller" {
  count = 1
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.2.3"
  namespace = "kube-system"


  set {
    name  = "controller.service.type"
    value = "NodePort"
  }


//  set {
//    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-name"
//    value = "apps-ingress-nlb"
//  }
//
//  set {
//    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
//    value = "external"
//  }
//
//  set {
//    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
//    value = "internal"
//  }
//
//  set {
//    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
//    value = "ip"
//  }
//
//  set {
//    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-healthcheck-protocol"
//    value = "http"
//  }
//
//  set {
//    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-healthcheck-path"
//    value = "/healthz"
//  }
//
//  set {
//    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-healthcheck-port"
//    value = "10254"
//  }

  depends_on = [
//    module.lb-controller,
    module.eks
  ]

}
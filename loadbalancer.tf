module "lb-controller" {
  source = "./modules/lb-controller"
  enabled = true
  cluster_name = local.cluster_name
  oidc = {
    url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
    arn = module.eks.oidc_provider_arn
  }

  depends_on = [
    module.eks
  ]
}

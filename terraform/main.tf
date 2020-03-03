module "cluster" {
  source = "./cluster"

  username = var.username
  password = var.password
}

module "deployments" {
  source = "./deployments"

  username               = var.username
  password               = var.username
  cluster_endpoint       = module.cluster.cluster_endpoint
  client_certificate     = module.cluster.client_certificate
  client_key             = module.cluster.client_key
  cluster_ca_certificate = module.cluster.cluster_ca_certificate
}
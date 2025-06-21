module "ecr" {
  source    = "./modules/ecr"
  repo_name = "myapp-repo"
  tags      = { Env = "dev" }
}



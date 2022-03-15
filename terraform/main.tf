module "cluster" {
  source  = "./modules/cluster"
  region  = "eu-west-1"
  profile = "development"
}
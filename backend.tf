terraform {
  backend "remote" {
    organization = "Org-new"
    
    workspaces {
      name = "terraform"
    }
  }
}
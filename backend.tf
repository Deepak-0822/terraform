terraform {
 backend "s3" {
   bucket       = "demo-tfstate2"
   key          = "usecase12"
   region       = "ap-south-1"
   use_lockfile = true
   encrypt = true 
 }
}
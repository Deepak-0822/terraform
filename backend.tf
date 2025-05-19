terraform {
 backend "s3" {
   bucket       = "demo-tfstate2"
   key          = "usecase11"
   region       = "ap-south-1"
   use_lockfile = true
   encrypt = true 
 }
}
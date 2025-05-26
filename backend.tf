terraform {
 backend "s3" {
   bucket       = "demo-tfstate-test"
   key          = "usecase16"
   region       = "ap-south-1"
   use_lockfile = true
   encrypt = true 
 }
}
terraform {
 backend "s3" {
   bucket       = "demo-tfstate-test"
   key          = "usecase17"
   region       = "ap-south-1"
   use_lockfile = true
   encrypt = true 
 }
}
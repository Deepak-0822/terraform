terraform {
 backend "s3" {
   bucket       = "demo-tfstate-test"
   key          = "usecase14-embeddings"
   region       = "ap-south-1"
   use_lockfile = true
   encrypt = true 
 }
}
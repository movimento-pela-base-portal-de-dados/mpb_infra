output "instance_id" { value = module.compute.instance_id }
output "public_ip" { value = module.compute.public_ip }
output "data_bucket" { value = module.storage.bucket_name }
output "vpc_id" { value = module.network.vpc_id }

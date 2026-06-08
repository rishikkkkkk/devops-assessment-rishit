output "resource_group_name" {
  value = module.resource_group.name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "aks_id" {
  value = module.aks.id
}

output "aks_name" {
  value = module.aks.name
}
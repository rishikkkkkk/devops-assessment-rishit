module "aks" {
  source  = "clouddrove/aks/azure"
  version = "1.0.2"

  name        = "assessment"
  environment = "dev"

  resource_group_name = module.resource_group.name
  location            = var.location

  kubernetes_version = "1.30"

  default_node_pool = {
    name                  = "system"
    vm_size               = "Standard_B2s"
    count                 = 2
    max_pods              = 110
    os_disk_size_gb       = 64
    enable_node_public_ip = false
  }

  vnet_id         = module.network.vnet_id
  nodes_subnet_id = module.network.private_subnet_id

  network_plugin = "azure"

  aks_sku_tier = "Free"

  oms_agent_enabled = false

  microsoft_defender_enabled = false

  diagnostic_setting_enable = false
}
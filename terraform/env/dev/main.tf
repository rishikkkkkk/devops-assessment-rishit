module "resource_group" {
  source = "../../modules/resource-group"

  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
}

module "network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = var.location

  vnet_name = "${var.project_name}-${var.environment}-vnet"

  vnet_cidr           = ["10.0.0.0/16"]
  public_subnet_cidr  = ["10.0.1.0/24"]
  private_subnet_cidr = ["10.0.2.0/24"]
}

module "nsg" {
  source = "../../modules/nsg"

  name                = "${var.project_name}-${var.environment}-nsg"
  location            = var.location
  resource_group_name = module.resource_group.name

  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
}

module "nat_gateway" {
  source = "../../modules/nat-gateway"

  name                = "${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = module.resource_group.name

  private_subnet_id = module.network.private_subnet_id
}

module "aks" {
  source  = "clouddrove/aks/azure"
  version = "1.0.2"

  name        = var.project_name
  environment = var.environment

  resource_group_name = module.resource_group.name
  location            = var.location

  kubernetes_version = "1.30"

  vnet_id         = module.network.vnet_id
  nodes_subnet_id = module.network.private_subnet_id

  default_node_pool = {
    name                  = "system"
    vm_size               = "Standard_D2s_v5"
    count                 = 2
    max_pods              = 110
    os_disk_size_gb       = 64
    enable_node_public_ip = false
  }

  network_plugin = "azure"

  aks_sku_tier = "Free"
}
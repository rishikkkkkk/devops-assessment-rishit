resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = var.vnet_cidr
}

resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = var.public_subnet_cidr
}

# for aks nodes

resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = var.private_subnet_cidr
}

# now we will be creating route tables for both:

resource "azurerm_route_table" "public" {
  name                = "public-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_route_table" "private" {
  name                = "private-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# after creating route tables we will associate it with the subnets

resource "azurerm_subnet_route_table_association" "public" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = azurerm_route_table.public.id
}

resource "azurerm_subnet_route_table_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private.id
}
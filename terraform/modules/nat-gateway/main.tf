resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_nat_gateway" "this" {
  name                = "${var.name}-nat"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "Standard"
}

# now associating public ip with nat

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.this.id
}

# attaching nat to private subnet

resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id      = var.private_subnet_id
  nat_gateway_id = azurerm_nat_gateway.this.id
}
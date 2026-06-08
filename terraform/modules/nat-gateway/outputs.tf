output "nat_gateway_id" {
  value = azurerm_nat_gateway.this.id
}

output "public_ip" {
  value = azurerm_public_ip.this.ip_address
}
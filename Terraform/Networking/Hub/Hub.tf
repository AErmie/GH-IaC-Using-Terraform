resource "azurerm_resource_group" "SharedServicesRG" {
  name     = "SharedServicesRG-GH"
  location = var.SharedServicesResourceGroupLocation
  tags = {
    Environment = var.Environment
    CostCenter  = var.CostCenter
  }
}

# NOTE: Have to create the NSGs first (and in the same TF file as the Subnets, instead of in its own module), 
# due to a bug in the AzureRM Provider (which "should" be fixed in v2.0)
resource "azurerm_network_security_group" "DomainControllerSubnetNSG" {
  name                = "DomainControllerSubnetNSG"
  location            = azurerm_resource_group.SharedServicesRG.location
  resource_group_name = azurerm_resource_group.SharedServicesRG.name
  tags = {
    Environment = var.Environment
    CostCenter  = var.CostCenter
  }
}

resource "azurerm_network_security_rule" "DomainControllerNSGRule_DNS" {
  name                        = "DNS_InBound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.DomainControllerSubnetNSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.DomainControllerSubnetNSG.name
}
resource "azurerm_network_security_rule" "DomainControllerNSGRule_LDAP" {
  name                        = "LDAP_InBound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.DomainControllerSubnetNSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.DomainControllerSubnetNSG.name
}
resource "azurerm_network_security_rule" "DomainControllerNSGRule_SSL" {
  name                        = "SSL_InBound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.DomainControllerSubnetNSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.DomainControllerSubnetNSG.name
}

resource "azurerm_network_security_rule" "DomainControllerNSGRule_LDAPS" {
  name                        = "LDAPS_InBound"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "636"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.DomainControllerSubnetNSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.DomainControllerSubnetNSG.name
}

resource "azurerm_network_security_rule" "DomainControllerNSGRule_RPCDynamicPorts" {
  name                        = "RPCDynamicPorts_InBound"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "49152-65535"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.DomainControllerSubnetNSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.DomainControllerSubnetNSG.name
}

resource "azurerm_network_security_rule" "DomainControllerNSGRule_Kerberos" {
  name                        = "Kerberos_InBound"
  priority                    = 160
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "464"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.DomainControllerSubnetNSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.DomainControllerSubnetNSG.name
}

resource "azurerm_network_security_rule" "DomainControllerNSGRule_RPC" {
  name                        = "RPC_InBound"
  priority                    = 170
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "135"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.DomainControllerSubnetNSG.resource_group_name
  network_security_group_name = azurerm_network_security_group.DomainControllerSubnetNSG.name
}

resource "azurerm_virtual_network" "SharedServicesVNET" {
  name                = "SharedServicesVNET"
  location            = azurerm_resource_group.SharedServicesRG.location
  resource_group_name = azurerm_resource_group.SharedServicesRG.name
  address_space       = [var.SharedServices-VNet-AddressSpace]
  tags = {
    Environment = var.Environment
    CostCenter  = var.CostCenter
  }
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  address_prefix       = var.SharedServices-GatewaySubnet-AddressPrefix
  resource_group_name  = azurerm_virtual_network.SharedServicesVNET.resource_group_name
  virtual_network_name = azurerm_virtual_network.SharedServicesVNET.name
}

resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  address_prefix       = var.SharedServices-AzureFirewallSubnet-AddressPrefix
  resource_group_name  = azurerm_virtual_network.SharedServicesVNET.resource_group_name
  virtual_network_name = azurerm_virtual_network.SharedServicesVNET.name
}

resource "azurerm_subnet" "DomainControllerSubnet" {
  name                      = "DomainControllerSubnet"
  address_prefix            = var.SharedServices-DomainControllerSubnet-AddressPrefix
  resource_group_name       = azurerm_virtual_network.SharedServicesVNET.resource_group_name
  virtual_network_name      = azurerm_virtual_network.SharedServicesVNET.name
}

resource "azurerm_subnet_network_security_group_association" "DomainController-NSGAssociation" {
  subnet_id                 = azurerm_subnet.DomainControllerSubnet.id
  network_security_group_id = azurerm_network_security_group.DomainControllerSubnetNSG.id
}
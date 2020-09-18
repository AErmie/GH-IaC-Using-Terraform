terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0"
    }
  }
  # Backend for configuring remote state files to Azure Storage
  backend "azurerm" {
    # NOTICE this is empty. This is because these values are supplied by the Pipeline!
    # resource_group_name   = "TerraformStateRG"
    # storage_account_name  = "terraformstatesaae"
    # container_name        = "tfstate"
    # key                   = "tf-statefile-peer.state"
  }
}

module "VNET-Peering" {
  source                        = "../../../VNetPeering"
  HubVNet-RGName                = data.azurerm_virtual_network.SharedServicesVNET.resource_group_name
  HubVNet-Name                  = data.azurerm_virtual_network.SharedServicesVNET.name
  HubNetwork-ID                 = data.azurerm_virtual_network.SharedServicesVNET.id
  HubVNet-AllowVNetAccess       = var.HubVNet-AllowVNetAccess
  HubVNet-AllowForwardedTraffic = var.HubVNet-AllowForwardedTraffic
  HubVNet-AllowGatewayTransit   = var.HubVNet-AllowGatewayTransit

  ProdVNet-RGName                = data.azurerm_virtual_network.ProdVNET.resource_group_name
  ProdVNet-Name                  = data.azurerm_virtual_network.ProdVNET.name
  ProdNetwork-ID                 = data.azurerm_virtual_network.ProdVNET.id
  ProdVNet-AllowVNetAccess       = var.ProdVNet-AllowVNetAccess
  ProdVNet-AllowForwardedTraffic = var.ProdVNet-AllowForwardedTraffic
  ProdVNet-AllowGatewayTransit   = var.ProdVNet-AllowGatewayTransit
}
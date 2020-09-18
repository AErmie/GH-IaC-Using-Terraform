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
    # key                   = "tf-statefile-spoke.state"
  }
}

provider "azurerm" {
  features {}
  #(Optional) The Subscription ID which should be used. This can also be sourced from the ARM_SUBSCRIPTION_ID Environment Variable.
  subscription_id = var.subscription_id
  #(Optional) The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable.
  client_id       = var.client_id
  client_secret   = var.client_secret
  #(Optional) The Tenant ID which should be used. This can also be sourced from the ARM_TENANT_ID Environment Variable.
  tenant_id       = var.tenant_id
  #(Optional) The Cloud Environment which should be used. Possible values are public, usgovernment, german and china. Defaults to public. This can also be sourced from the ARM_ENVIRONMENT environment variable.
  environment = "public"
}

module "vnets-Prod" {
  source      = "../../../Spoke-Prod/"
  Environment = "Production"
  CostCenter  = "67890"

  Prod-ResourceGroupLocation    = var.Prod-ResourceGroupLocation
  Prod-VNet-AddressSpace        = var.Prod-VNet-AddressSpace
  Prod-WebSubnet-AddressPrefix  = var.Prod-WebSubnet-AddressPrefix
  Prod-AppSubnet-AddressPrefix  = var.Prod-AppSubnet-AddressPrefix
  Prod-DataSubnet-AddressPrefix = var.Prod-DataSubnet-AddressPrefix
}
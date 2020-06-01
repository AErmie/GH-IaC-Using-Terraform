provider "azurerm" {
  version = ">=2.0.0"
  //   subscription_id = ""
  #(Optional) The Subscription ID which should be used. This can also be sourced from the ARM_SUBSCRIPTION_ID Environment Variable.

  //   client_id = ""
  #(Optional) The Client ID which should be used. This can also be sourced from the ARM_CLIENT_ID Environment Variable.
  //   client_secret = ""
  //   tenant_id     = ""
  #(Optional) The Tenant ID which should be used. This can also be sourced from the ARM_TENANT_ID Environment Variable.

  environment = "public"
  #(Optional) The Cloud Environment which should be used. Possible values are public, usgovernment, german and china. Defaults to public. This can also be sourced from the ARM_ENVIRONMENT environment variable.
}

# Allows what version of Terraform to use.
terraform {
  required_version = ">=0.12.0"
  # Backend for configuring remote state files to Azure Storage

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
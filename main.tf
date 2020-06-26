provider azurerm {
    features {}
    version = "~> 2.16"
}

# RG
resource "azurerm_resource_group" "rg" {
  name      = "${lower(var.envprefix)}RG"
  location  = var.location
}

# AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "omegamadlab-tfonaz-4-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "omegamadlab-tfonaz-4-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "demo"
  }
}

# ACR
resource "azurerm_container_registry" "acr" {
  name                     = "omegamadlabtfonaz4acr"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = false
}




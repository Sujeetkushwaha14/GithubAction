provider "azurerm" {
  features {}
  subscription_id = "1212a59c-637f-45eb-8b74-8032483be797"
}

resource "azurerm_resource_group" "rg" {
  name     = "sujeetrg1"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "autosujeetgit"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "autodsujeetgit"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "autodeploy"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_a2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_container_registry.acr]
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}


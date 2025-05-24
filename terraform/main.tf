// Конфигурация провайдера и ресурсов для подключения к ESXi и клонирования ВМ из шаблона.

terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">=2.1.1"               // минимум версии плагина
    }
  }
}

provider "vsphere" {
  user                 = var.esxi_user  // имя пользователя ESXi
  password             = var.esxi_password // пароль ESXi
  vsphere_server       = var.esxi_host  // адрес ESXi
  allow_unverified_ssl = true           // игнорировать самоподписанные сертификаты
}

//
// Получаем объекты из ESXi по имени для дальнейшего использования
//

data "vsphere_datacenter" "dc" {
  name = var.datacenter            // датацентр в ESXi
}

data "vsphere_datastore" "ds" {
  name          = var.datastore    // хранилище (Datastore)
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster      // название кластера
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "net_virtual" {
  name          = var.network_virtual // виртуальная сеть (/22)
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "net_infra" {
  name          = var.network_infra // инфраструктурная сеть (/26)
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template  // шаблон ВМ (например, Linux-template)
  datacenter_id = data.vsphere_datacenter.dc.id
}

//
// Ресурс vsphere_virtual_machine.vm создаёт ВМ на основе шаблона.
// count = length(var.vm_specs) — один ресурс на каждый элемент vm_specs.
//
resource "vsphere_virtual_machine" "vm" {
  count            = length(var.vm_specs)
  name             = var.vm_specs[count.index].name       // имя ВМ
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id

  // Аппаратные характеристики
  num_cpus = var.vm_specs[count.index].cpus               // число виртуальных CPU
  memory   = var.vm_specs[count.index].memory             // оперативная память в МБ

  // Сетевой интерфейс: выбираем VLAN по use_infra-флагу
  network_interface {
    network_id   = var.vm_specs[count.index].use_infra 
      ? data.vsphere_network.net_infra.id 
      : data.vsphere_network.net_virtual.id
    adapter_type = "vmxnet3"
  }

  // Диск: тонкое Provision’ение по умолчанию
  disk {
    label            = "disk0"
    size             = var.vm_specs[count.index].disk    // диск в ГБ
    thin_provisioned = true
  }

  // Клонирование из шаблона с настройкой ОС
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.vm_specs[count.index].hostname  // hostname внутри гостевой ОС
        domain    = var.domain_name
      }

      // Настройка сети внутри гостевой ОС
      network_interface {
        ipv4_address = var.vm_specs[count.index].ip
        ipv4_netmask = var.vm_specs[count.index].netmask
      }

      ipv4_gateway = var.gateway
      dns_servers  = var.dns_servers
    }
  }
}
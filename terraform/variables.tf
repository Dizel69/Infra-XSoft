// Определяем набор переменных для подключения к ESXi и списка ВМ.

variable "esxi_host" {
  description = "Адрес ESXi (IP или hostname)"
  type        = string
}

variable "esxi_user" {
  description = "Имя пользователя ESXi"
  type        = string
}

variable "esxi_password" {
  description = "Пароль пользователя ESXi"
  type        = string
  sensitive   = true
}

variable "datacenter" {
  description = "Имя датацентра в ESXi"
  type        = string
}

variable "datastore" {
  description = "Имя Datastore в ESXi"
  type        = string
}

variable "cluster" {
  description = "Имя Compute Cluster в ESXi"
  type        = string
}

variable "network_virtual" {
  description = "Сеть виртуализации (/22 — 1024 адреса)"
  type        = string
}

variable "network_infra" {
  description = "Сеть инфраструктуры (/26 — 64 адреса)"
  type        = string
}

variable "vm_template" {
  description = "Имя шаблона виртуальной машины"
  type        = string
}

variable "domain_name" {
  description = "Домен для гостевых ОС (например, xsoft.local)"
  type        = string
}

variable "gateway" {
  description = "Адрес шлюза внутри гостевой сети"
  type        = string
}

variable "dns_servers" {
  description = "Список DNS-серверов внутри гостевых ОС"
  type        = list(string)
}

variable "vm_specs" {
  description = <<EOF
Список объектов с параметрами ВМ:
- name:      логическое имя в Terraform
- hostname:  hostname внутри гостевой ОС
- ip:        статический IP
- netmask:   длина маски (24 = 255.255.255.0)
- cpus:      число виртуальных CPU
- memory:    RAM в МБ
- disk:      диск в ГБ
- use_infra: если true — подключить к сети инфраструктуры (/26), иначе к виртуализации (/22)
EOF
  type = list(object({
    name      = string
    hostname  = string
    ip        = string
    netmask   = number
    cpus      = number
    memory    = number
    disk      = number
    use_infra = bool
  }))
}
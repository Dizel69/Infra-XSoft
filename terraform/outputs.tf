// Выводим IP-адреса всех созданных ВМ.

output "vm_ips" {
  description = "Словарь имя_вм → её IP"
  value = {
    for vm in vsphere_virtual_machine.vm :
    vm.name => vm.default_ip_address
  }
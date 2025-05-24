esxi_host     = "esxi.xsoft.local"
esxi_user     = "root"
esxi_password = "YourSecurePassword"
datacenter    = "DC1"
datastore     = "datastore1"
cluster       = "Cluster1"
network_virtual = "VM-Network01"
network_infra   = "VM-Network02"
vm_template     = "linux-template"
domain_name     = "xsoft.local"
gateway         = "10.0.1.1"
dns_servers     = ["10.0.1.10", "8.8.8.8"]

vm_specs = [
  {
    name      = "ipa1"
    hostname  = "ipa1"
    ip        = "10.0.1.10"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 50
    use_infra = true
  },
  {
    name      = "ipa2"
    hostname  = "ipa2"
    ip        = "10.0.1.11"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 50
    use_infra = true
  },
  {
    name      = "gitlab"
    hostname  = "gitlab"
    ip        = "10.0.1.20"
    netmask   = 24
    cpus      = 4
    memory    = 8192
    disk      = 100
    use_infra = true
  },
  {
    name      = "k8s-master1"
    hostname  = "k8s-master1"
    ip        = "10.0.2.10"
    netmask   = 24
    cpus      = 2
    memory    = 8192
    disk      = 50
    use_infra = false
  },
  {
    name      = "k8s-worker1"
    hostname  = "k8s-worker1"
    ip        = "10.0.2.11"
    netmask   = 24
    cpus      = 2
    memory    = 8192
    disk      = 50
    use_infra = false
  },
  {
    name      = "k8s-worker2"
    hostname  = "k8s-worker2"
    ip        = "10.0.2.12"
    netmask   = 24
    cpus      = 2
    memory    = 8192
    disk      = 50
    use_infra = false
  },
  {
    name      = "ceph1"
    hostname  = "ceph1"
    ip        = "10.0.1.30"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 200
    use_infra = true
  },
  {
    name      = "ceph2"
    hostname  = "ceph2"
    ip        = "10.0.1.31"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 200
    use_infra = true
  },
  {
    name      = "ceph3"
    hostname  = "ceph3"
    ip        = "10.0.1.32"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 200
    use_infra = true
  },
  {
    name      = "prom"
    hostname  = "prom"
    ip        = "10.0.1.40"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 50
    use_infra = true
  },
  {
    name      = "graf"
    hostname  = "graf"
    ip        = "10.0.1.41"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 50
    use_infra = true
  },
  {
    name      = "moodle"
    hostname  = "moodle"
    ip        = "10.0.1.50"
    netmask   = 24
    cpus      = 2
    memory    = 4096
    disk      = 50
    use_infra = true
  },
  {
    name      = "fw"
    hostname  = "fw"
    ip        = "10.0.1.1"
    netmask   = 24
    cpus      = 1
    memory    = 2048
    disk      = 10
    use_infra = true
  },
]

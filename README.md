# Infra-XSoft
Проект автоматизации развёртки DevOps-инфраструктуры для ООО «Xsoft».

## Структура проекта

```
infra-xsoft/                                 # Корневая директория проекта
├── README.md                                # Описание проекта и инструкция по развёртыванию
├── terraform/                               # IaC на Terraform для создания ВМ в ESXi
│   ├── main.tf                              # Основная конфигурация и ресурсы
│   ├── variables.tf                         # Объявление переменных
│   ├── variables.tfvars                     # Значения переменных (персональный файл)
│   └── outputs.tf                           # Вывод IP-адресов и других данных
├── ansible/                                 # Конфигурация Ansible для настройки сервисов
│   ├── ansible.cfg                          # Основной конфиг Ansible (inventory, пути)
│   ├── inventory.ini                        # Инвентори-хосты по группам
│   ├── group_vars/                          # Переменные для групп хостов
│   │   ├── all.yml                          # Общие переменные для всех хостов
│   │   └── k8s.yml                          # Переменные для группы k8s
│   ├── roles/                               # Набор ролей для настройки сервисов
│   │   ├── freeipa/                         # Роль FreeIPA (LDAP/Kerberos)
│   │   │   ├── defaults/main.yml            # Переменные роли по умолчанию
│   │   │   ├── tasks/main.yml               # Задачи установки и настройки FreeIPA
│   │   │   └── templates/freeipa-setup.j2   # Шаблон /etc/ipa/default.conf
│   │   ├── gitlab/                          # Роль GitLab CE
│   │   │   ├── defaults/main.yml            # Переменные роли по умолчанию
│   │   │   ├── tasks/main.yml               # Задачи установки и конфигурирования GitLab
│   │   │   └── templates/gitlab.rb.j2       # Шаблон /etc/gitlab/gitlab.rb
│   │   ├── k8s/                             # Роль Kubernetes
│   │   │   ├── defaults/main.yml            # Переменные роли по умолчанию
│   │   │   ├── tasks/bootstrap.yml          # Инициализация control-plane
│   │   │   ├── tasks/join.yml               # Присоединение воркеров
│   │   │   └── templates/calico.yaml.j2     # Шаблон манифеста Calico CNI
│   │   ├── ceph/                            # Роль Ceph (распределённое хранилище)
│   │   │   ├── defaults/main.yml            # Переменные роли по умолчанию
│   │   │   ├── tasks/main.yml               # Задачи установки и настройки Ceph
│   │   │   └── templates/ceph.conf.j2       # Шаблон ceph.conf
│   │   ├── prometheus/                      # Роль Prometheus (мониторинг)
│   │   │   ├── defaults/main.yml            # Переменные роли по умолчанию
│   │   │   ├── tasks/main.yml               # Задачи установки и запуска Prometheus
│   │   │   └── templates/prometheus.yml.j2  # Шаблон prometheus.yml
│   │   ├── grafana/                         # Роль Grafana (дашборды)
│   │   │   ├── defaults/main.yml            # Переменные роли по умолчанию
│   │   │   ├── tasks/main.yml               # Задачи установки и настройки Grafana
│   │   │   └── templates/datasource.yml.j2  # Шаблон Datasource JSON
│   │   ├── moodle/                          # Роль Moodle (тестовая платформа)
│   │   │   ├── defaults/main.yml            # Переменные роли по умолчанию
│   │   │   ├── tasks/main.yml               # Задачи установки LAMP и Moodle
│   │   │   └── templates/moodle-config.j2   # Шаблон config.php
│   │   └── firewall/                        # Роль VyOS firewall/router
│   │       ├── defaults/main.yml            # Переменные роли по умолчанию
│   │       ├── tasks/main.yml               # Задачи генерации и пуша конфигурации
│   │       └── templates/vyos-config.j2     # Скрипт конфигурации VyOS
│   └── playbooks/site.yml                   # Главный playbook Ansible
└── docs/                                    # Доп. документация и CI-конфиги
    ├── READMEdev.md                         # Дополнительный файл описания для разработчиков с инфраструктурой
    └── .gitlab-ci.yml                       # CI/CD для этого репозитория
```

## Краткое описание

Проект автоматизирует развёртывание инфраструктуры полного цикла разработки и тестирования ПО:

* **FreeIPA**: LDAP/Kerberos-домен для единой аутентификации
* **GitLab CE**: система контроля версий и встроенный CI/CD
* **Kubernetes**: кластер (1 master + минимум 2 workers) с Calico CNI
* **Ceph**: отказоустойчивое распределённое хранилище
* **Prometheus**: сбор метрик кластера и сервисов
* **Grafana**: дашборды для визуализации метрик
* **Moodle**: платформа для тестирования полного цикла разработки
* **VyOS firewall**: маршрутизация и правила межсетевого экранирования

Используются открытые и отечественные решения, а вся логика — в виде кода (Terraform + Ansible).

## Подготовка машины

Убедитесь, что на управляющей машине установлены Terraform и Ansible.

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y software-properties-common curl gnupg

# Установка Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install -y terraform

# Установка Ansible
sudo apt install -y ansible
ansible-galaxy collection install community.general community.vmware kubernetes.core ceph.ceph
```

## Развёртывание инфраструктуры через Terraform

```bash
cd infra-xsoft/terraform
# подготовить variables.tfvars с реальными значениями
terraform init
terraform plan    # проверить изменения
terraform apply   # создать ВМ в ESXi
```

> **Важно**: файл `variables.tfvars` содержит пароли и IP. Храните его в безопасности и не коммитьте в Git.

## Настройка сервисов через Ansible

```bash
cd ../ansible
# при необходимости скорректировать inventory.ini и group_vars
ansible-playbook ./playbooks/site.yml
```

> После выполнения плейбука роли автоматически настроят FreeIPA, GitLab, k8s, Ceph, мониторинг, дашборды, Moodle и firewall.

## Заключение

Теперь у вас готова отказоустойчивая, автоматизированная DevOps-платформа для разработки, тестирования и запуска приложений.

**TODO**:

* Добавляйте новые роли и сервисы по аналогии
* Интегрируйте GitLab CI/CD для автоматической проверки Terraform и Ansible
* Расширяйте мониторинг и алерты


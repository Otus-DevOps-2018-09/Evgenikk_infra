# Evgenikk_infra
Evgenikk Infra repository

### Данные для подключения:
```
bastion_IP = 35.207.138.155
someinternalhost_IP = 10.156.0.3

testapp_IP = 35.242.229.74 
testapp_port = 9292
```
### Работа с GCP (web)

Подключение к someiternalhost в одну команду:
```
 ssh -o ProxyCommand="ssh Radio@35.207.138.155 nc %h %p" Radio@10.156.0.3
 ssh -tt -A Radio@35.207.138.155 ssh -tt Radio@10.156.0.3
```


Для подключения к somiternalhost коммандой "ssh someiternalhost" в файл .ssh/config нужно добавить следующий блок:
```
Host someiternalhost
hostname 10.156.0.3
port 22
user Radio
ProxyCommand ssh Radio@35.207.138.155 nc %h %p
```
### Работа с GCP (консоль)
Для создания правила в firewall на puma-server  используется комманда:
```
gcloud compute firewall-rules create default-puma-server --allow=TCP:9292 --target-tags=puma-server
```
Для развертывания в gcloud приложения с использованием startup-script использовал:
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file=startup-script=./startup.sh
```

Для добалвения правила в фаервол через  gcloud:
```
gcloud compute firewall-rules create 
default-puma-server 
--allow tcp:9292 
--target-tags puma-server 

```

### Packer
Для создания образа  reddit-base:
```
packer build ubuntu16.json
```
Для создания образа reddit-full:
```
packer build immutable.json
```
Переменные  для создания обоих образов содержаться в файле /packer/variables.json

### Terraform
При добавлении одного ключа через terraform подключение происходит успешно, добавляя множество одинаковых ключей для разных пользователей, подключаться не удается (host key verification failed). Формат добавленных ключей в обоих ситуациях совпадает.


lb.tf создает балансировщик нагрузки между инстансами. Балансировщик  перенаправляет http  запросы полученный на свой внешний ip на один из инстансов с приложением на порт 9292. При отключении одного инстанса через некоторое время доступ к приложению возобновляется.

Все переменные содержаться в  terraform.tfvars. Значения переменных по умолчанию можно посмотреть в  variables.tf


### Terraform-2 

Были написаны модули для создания двух виртуальных машин с базой данных (db module ) и с приложением (app module).
Модули используются в файлах main.tf папок   stage и prod.
Созданы два bucket, для этого используется /terraform/storage-bucket.tf .
Настроено хранение и использование   terraform.tfstate в удаленном бэкенде, в созданных ранее buckets. Для этого используется /terraform/stage/backend.tf.
В модуле app  закоментирован provisioner, так как поставленную задачу еще не решает, но успешно запускается. Оставил как пример на будущее.


### Ansible-1 
В ходе работы:
Установлен ansible
Созданы файлы inventory и inventory.yml
В ansible.cfg был задан путь к  invetory и параметры подключения
Запущены удаленно модули  ping, command, git, servicem, systemd, shell 
Написан и запущен  playbook для копирования файлов с удаленного репозитория


При первом использовании playbook ansible не внес никаких изменений в конфигурацию системы, т. к.  файлы уже были скопированны ранее, при повторном запуске playbook ansible обнаружил отстутсвие файлов и скачал их с репозитория.

### Ansible-2
В ходе работы:
Был использован ansible для деплоя приложения с тремя разными подходами к организации файлов ansible.
Созданы packer_db.yml и packer_app.yml для замены скриптов /packer/scripts/install_mongodb.sh  и install_ruby.sh соответсвенно
Был использован ansible  в качестве provisioner для packer. (Packer генерирует dynamic inventory для использования написанного playbook).
Запущено приложение  reddit с использованием новых образов  packer и  ansible/site.yml

### Ansible-3
Перенесено развертывание приложения и базы данных в роли.
Использована роль из  ansible galaxy для проксирования http  трафика к приложению
Добавлены пользователи на app и db  виртуальные машины при помощи ansible
Использован vault.key для шифрования данных о паролях и именах добавленных пользователей
В .travis.yml добавлено два скрипта. install_utills.sh устанавливает все необходимые для тестирования пакеты, а syntax_test.sh  выполняет packer validate, tflint, terraform validate и ansible-lint.

### Ansible-3
Был использован Vagrant для развертывания локального окружения. 
При помощи Molecule протестирована роль  db, а именно проверены значения  bind ip и port в /etc/mongo.conf, а также статус сервиса.
Переделаны packer_app.yml и packer_db.yml под запуско ролей app и  db, внутри себя соответсвенно, а при помощи app.json и db.json запущены эти плейбуки с нужными тэгами.

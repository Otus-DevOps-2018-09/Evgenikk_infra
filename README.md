# Evgenikk_infra
Evgenikk Infra repository

#Данные для подключения:
```
bastion_IP = 35.207.138.155
someinternalhost_IP = 10.156.0.3

testapp_IP = 35.242.229.74 
testapp_port = 9292
```
#Работа с GCP (web)

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
#Работа с GCP (консоль)
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

#Packer
Для создания образа  reddit-base:
```
packer build ubuntu16.json
```
Для создания образа reddit-full:
```
packer build immutable.json
```
Переменные  для создания обоих образов содержаться в файле /packer/variables.json

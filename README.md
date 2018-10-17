# Evgenikk_infra
Evgenikk Infra repository
Данные для подключения:
bastion_IP = 35.207.138.155
someinternalhost_IP = 10.156.0.3

Подключение к someiternalhost в одну команду:

 ssh -o ProxyCommand="ssh Radio@35.207.138.155 nc %h %p" Radio@10.156.0.3
 ssh -tt -A Radio@35.207.138.155 ssh -tt Radio@10.156.0.3

Для подключения к somiternalhost коммандой "ssh someiternalhost" в файл .ssh/config нужно добавить следующий блок:

Host someiternalhost
hostname 10.156.0.3
port 22
user Radio
ProxyCommand ssh Radio@35.207.138.155 nc %h %p



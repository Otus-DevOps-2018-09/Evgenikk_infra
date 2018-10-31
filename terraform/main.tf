provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

#Читаем ключ и загружаем его копии в GCP
data "local_file" "appuser_key" {
  filename = "${var.public_key_path}"
}

resource "google_compute_project_metadata" "add_keys" {
  metadata {
    #ssh-keys =  <<EOF
    #appuser1:${chomp(data.local_file.appuser_key.content)} appuser1@MacBook-Pro-Radio.local
    #appuser2:${chomp(data.local_file.appuser_key.content)} appuser2@MacBook-Pro-Radio.local
    #appuser3:${chomp(data.local_file.appuser_key.content)}  appuser3@MacBook-Pro-Radio.local
    #Radio:${chomp(data.local_file.appuser_key.content)} Radio@MacBook-Pro-Radio.local
    #EOF
    ssh-keys = "Radio:${chomp(data.local_file.appuser_key.content)} Radio@MacBook-Pro-Radio.local"
  }

  project = "${var.project}"
}

#Разворачиваем приложение
resource "google_compute_instance" "app" {
  name         = "reddit-app-${count.index + 1}"
  machine_type = "g1-small"
  zone         = "${var.region}"
  count        = "${var.app_count}"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  tags = ["reddit-app"]

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

#Добавляем ключи в метаданные проекта


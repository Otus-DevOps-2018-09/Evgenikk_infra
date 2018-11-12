#Создаем Healthcheck
resource "google_compute_http_health_check" "reddit_health_check" {
  name               = "redditapphealth"
  timeout_sec        = 1
  check_interval_sec = 1
  request_path       = "/"
  port               = 9292
}

#Объединяем машины с приложением в общую группу 
resource "google_compute_instance_group" "reddit_app_group" {
  name      = "reddit-app-inst-group"
  instances = ["${google_compute_instance.app.*.self_link}"]

  named_port {
    name = "puma-9292"
    port = "9292"
  }

  zone = "${var.region}"
}

# Создаем backend, который опираясь на  healthcheck будет перенаправлять трафик на instance
resource "google_compute_backend_service" "reddit_backend" {
  name          = "reddit-back"
  health_checks = ["${google_compute_http_health_check.reddit_health_check.self_link}"]

  backend = {
    group = "${google_compute_instance_group.reddit_app_group.self_link}"
  }

  port_name   = "puma-9292"
  protocol    = "HTTP"
  timeout_sec = 5
}

resource "google_compute_url_map" "reddit_url_map" {
  name            = "reddit-map"
  description     = "url map for reddit "
  default_service = "${google_compute_backend_service.reddit_backend.self_link}"
}

resource "google_compute_target_http_proxy" "reddit_http_proxy" {
  name    = "reddit-proxy"
  url_map = "${google_compute_url_map.reddit_url_map.self_link}"
}

resource "google_compute_global_forwarding_rule" "reddit_forwarding_rule" {
  name       = "reddit-fwrule"
  target     = "${google_compute_target_http_proxy.reddit_http_proxy.self_link}"
  port_range = "80"
}

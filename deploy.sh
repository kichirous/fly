#!/bin/sh

curl -L https://fly.io/install.sh | FLYCTL_INSTALL=/usr/local sh

flyctl apps create "${APP_NAME}"

cat <<EOF >./fly.toml
app = "$APP_NAME"

kill_signal = "SIGINT"
kill_timeout = 5
processes = []

[env]

[experimental]
  allowed_public_ports = []
  auto_rollback = true

[[services]]
  http_checks = []
  internal_port = 8080
  processes = ["app"]
  protocol = "tcp"
  script_checks = []
  [services.concurrency]
    hard_limit = 25
    soft_limit = 20
    type = "connections"

  [[services.ports]]
    force_https = true
    handlers = ["http"]
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443

  [[services.tcp_checks]]
    grace_period = "1s"
    interval = "15s"
    restart_limit = 0
    timeout = "2s"
EOF

flyctl secrets set UUID="${UUID}"

flyctl regions set lax

printf '\e[32mApp secrets and regions set success. Next, deploy the app.\n\e[0m'

flyctl deploy --detach

flyctl status --app ${APP_NAME}

# airport-deploy

Reusable deployment framework for a private multi-user proxy service.

## Stack

- Ubuntu 24.04
- Docker
- Docker Compose
- Marzban
- Hysteria2
- VLESS Reality

## Current Status

- v0.1.0: server bootstrap completed
- v0.2.0: Marzban panel deployed

## Dashboard Access

Use SSH tunnel:

    ssh -L 8000:127.0.0.1:8000 ubuntu@SERVER_IP

Open:

    http://127.0.0.1:8000/dashboard/

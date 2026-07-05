# Architecture

## Goal

A reusable deployment framework for a private multi-user proxy service.

## Components

- Ubuntu 24.04
- Docker
- Docker Compose
- Marzban
- Hysteria2
- VLESS Reality

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | TCP | SSH |
| 8000 | TCP | Marzban Panel |
| 8443 | UDP | Hysteria2 |
| 443 | TCP | VLESS Reality |

## Server Path

Default server installation path:

    /opt/airport

## Security Rule

Public GitHub repository only stores code and templates.

Secrets, keys, users, databases, and generated runtime configs must never be committed.

# Marzban

## Dashboard Access

Marzban is bound to localhost by default when SSL is not configured.

Use SSH port forwarding from local machine:

    ssh -L 8000:127.0.0.1:8000 ubuntu@SERVER_IP

Then open:

    http://127.0.0.1:8000/dashboard/

## Data Path

Marzban runtime data is stored on server:

    /var/lib/marzban

## Docker Service

Check service:

    sudo docker ps
    sudo docker logs --tail=80 marzban

Restart service:

    cd /opt/airport/compose
    sudo docker compose restart

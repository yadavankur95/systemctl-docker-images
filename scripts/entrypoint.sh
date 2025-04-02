#!/usr/bin/env bash

echo "Do Something"
echo "systemctl enable <service.name> to start any systemctl based service on startup"

# Check if custom-entrypoint.sh exists and is executable
if [ -x "./custom-entrypoint.sh" ]; then
    echo "Executing custom entrypoint script..."
    ./custom-entrypoint.sh
fi

exec "$@"
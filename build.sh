#!/bin/bash

echo "Building API containers..."
sudo -E docker compose -p models-api-proxy up -d --build --remove-orphans

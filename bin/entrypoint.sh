#!/bin/sh
echo "Starting traefik..."
traefik -c $TOML

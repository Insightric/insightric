#!/bin/bash
set -e

echo "Setting up Insightric microservices platform..."

# Initialize and update submodules
echo "Initializing git submodules..."
git submodule init
git submodule update --init --recursive

# Verify submodules
echo "Verifying submodules..."
git submodule status

echo "Setup complete!"

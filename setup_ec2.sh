#!/bin/bash

# First, install Elixir/Erlang using the Ubuntu repos
sudo apt-get update
sudo apt-get install -y erlang elixir nodejs npm git build-essential

# Clone your project (if not already done)
cd ~

cd nila

# Generate a new secret key
SECRET=$(mix phx.gen.secret)

# Create production environment file
cat > .env.production << EOL
MIX_ENV=prod
PHX_SERVER=true
SECRET_KEY_BASE=$SECRET
PHX_HOST="niladict.in"
PORT=4000
EOL

# Source the environment
source .env.production

# Add the iptables rule to forward port 80 to 4000
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 4000
sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -o lo -j REDIRECT --to-ports 4000

# Save the iptables rules to persist across reboots
sudo apt-get install -y iptables-persistent
# When prompted, select "Yes" to save current rules

# Or manually save:
sudo netfilter-persistent save

# Verify the rules
sudo iptables -t nat -L -n -v

# Install dependencies and build
mix local.hex --force
mix local.rebar --force
mix deps.get --only prod
mix compile

# Install and setup assets tools
mix esbuild.install
mix tailwind.install

# Build and deploy assets
mix assets.deploy

# Create systemd service
sudo tee /etc/systemd/system/nila.service > /dev/null << EOL
[Unit]
Description=Nila Phoenix App
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
Restart=on-failure
RestartSec=5
EnvironmentFile=/home/ubuntu/nila/.env.production
WorkingDirectory=/home/ubuntu/nila
ExecStart=/usr/bin/mix phx.server
ExecStop=/bin/kill -TERM \$MAINPID

[Install]
WantedBy=multi-user.target
EOL

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable nila
sudo systemctl start nila

# Check status
sudo systemctl status nila
#!/bin/bash

# First, install Elixir/Erlang using the Ubuntu repos
sudo apt-get update
# uncomment this line to install erlang elixir nodejs npm git build-essential
# sudo apt-get install -y erlang elixir nodejs npm git build-essential

# Clone your project (if not already done)
cd ~

cd nila

# Generate a new secret key
SECRET=$(mix phx.gen.secret)

# Create production environment file
cat > .env.production << EOL
export MIX_ENV=prod
export PHX_SERVER=true
export SECRET_KEY_BASE=$SECRET
export PHX_HOST="niladict.in"
export PORT=4000
export SSL_KEY_PATH=/etc/letsencrypt/live/niladict.in/privkey.pem
export SSL_CERT_PATH=/etc/letsencrypt/live/niladict.in/fullchain.pem
EOL

# Create systemd-compatible environment file
cat > /home/ubuntu/nila/.env.systemd << EOL
MIX_ENV=prod
PHX_SERVER=true
SECRET_KEY_BASE=$SECRET
PHX_HOST=niladict.in
PORT=4000
SSL_KEY_PATH=/etc/letsencrypt/live/niladict.in/privkey.pem
SSL_CERT_PATH=/etc/letsencrypt/live/niladict.in/fullchain.pem
EOL

# Source the environment
source .env.production

# Add the iptables rule to forward port 80 to 4000
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 4000
sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -o lo -j REDIRECT --to-ports 4000

sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 4001
sudo iptables -t nat -A OUTPUT -p tcp --dport 443 -o lo -j REDIRECT --to-ports 4001


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
MIX_ENV=prod mix compile

# Install and setup assets tools
mix esbuild.install
mix tailwind.install



# Build and deploy assets for production
MIX_ENV=prod mix assets.deploy

# Build the release
MIX_ENV=prod mix release --overwrite

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
EnvironmentFile=/home/ubuntu/nila/.env.systemd
WorkingDirectory=/home/ubuntu/nila
ExecStart=/home/ubuntu/nila/_build/prod/rel/nila/bin/nila start
ExecStop=/home/ubuntu/nila/_build/prod/rel/nila/bin/nila stop

[Install]
WantedBy=multi-user.target
EOL

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable nila
sudo systemctl start nila

# Check status
sudo systemctl status nila
# Olam

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix




Deploy command 

vi ~/nila/.env.production
sudo systemctl restart nila

logs:
  sudo systemctl status nila
  sudo journalctl -u nila -f
  sudo journalctl -u nila -n 50 --no-pager


  curl http://localhost:4000



  scp -i secet.pem setup_ec2.sh ubuntu@ip:~/


# Reload and restart
sudo systemctl daemon-reload
sudo systemctl restart nila

# Check status
sudo systemctl status nila
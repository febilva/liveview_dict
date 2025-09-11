# Nila Malayalam Dictionary (നിള മലയാളം നിഘണ്ടു)

A free, open-source English to Malayalam dictionary web application built with Phoenix LiveView. Perfect for Kerala students, professionals, and Malayalam learners worldwide.

## 🌟 Features

- **Instant Search**: Real-time English to Malayalam word translation
- **Clean Interface**: Simple, user-friendly design optimized for mobile and desktop
- **SEO Optimized**: Fully optimized for search engines with structured data
- **Accessibility**: Screen reader friendly with proper ARIA labels
- **Open Data**: Uses open-source Malayalam dictionary data under ODbL license

## 🚀 Getting Started

### Development

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Production Deployment

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
defmodule Olam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OlamWeb.Telemetry,
      Olam.Repo,
      {DNSCluster, query: Application.get_env(:olam, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Olam.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Olam.Finch},
      # Start a worker by calling: Olam.Worker.start_link(arg)
      # {Olam.Worker, arg},
      # Start to serve requests, typically the last entry
      OlamWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Olam.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OlamWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
